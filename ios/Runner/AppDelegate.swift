import UIKit
import Photos
import Flutter
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
    let errorMessage = "Failed to save, please check whether the permission is enabled"
    
    var flutterEngine = FlutterEngine(name: "FlutterEngine")
    var replayKitChannel: FlutterMethodChannel! = nil
    var observeTimer: Timer?
    var hasEmittedFirstSample = false
    var result: FlutterResult?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        flutterEngine.run()
        
        let controller =
        FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        
        let gallerySaverChannel = FlutterMethodChannel(name: "waterbus/gallery-saver",binaryMessenger: controller.binaryMessenger)
        let pictureInPictureChannel = FlutterMethodChannel(name: "waterbus/picture-in-picture",binaryMessenger: controller.binaryMessenger)
        replayKitChannel = FlutterMethodChannel(name: "waterbus-sdk/replaykit-channel",binaryMessenger: controller.binaryMessenger)
        
        pictureInPictureChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping  FlutterResult)  -> Void in
            switch (call.method) {
            case "startPictureInPicture":
                let arguments = call.arguments as? [String: Any] ?? [String: Any]()
                let remoteStreamId = arguments["remoteStreamId"] as? String ?? ""
                let peerConnectionId = arguments["peerConnectionId"] as? String ?? ""
                let isRemoteCameraEnable = arguments["isRemoteCameraEnable"] as? Bool ?? false
                let myAvatar = arguments["myAvatar"] as? String ?? ""
                let remoteAvatar = arguments["remoteAvatar"] as? String ?? ""
                let remoteName = arguments["remoteName"] as? String ?? ""
                
                WaterbusViewController.shared.configurationPictureInPicture(result: result, peerConnectionId: peerConnectionId, remoteStreamId: remoteStreamId, isRemoteCameraEnable: isRemoteCameraEnable, myAvatar: myAvatar, remoteAvatar: remoteAvatar, remoteName: remoteName)
            case "updatePictureInPicture":
                let arguments = call.arguments as? [String: Any] ?? [String: Any]()
                let peerConnectionId = arguments["peerConnectionId"] as? String ?? ""
                let remoteStreamId = arguments["remoteStreamId"] as? String ?? ""
                let isRemoteCameraEnable = arguments["isRemoteCameraEnable"] as? Bool ?? false
                let remoteAvatar = arguments["remoteAvatar"] as? String ?? ""
                let remoteName = arguments["remoteName"] as? String ?? ""
                WaterbusViewController.shared.updatePictureInPictureView(result, peerConnectionId: peerConnectionId, remoteStreamId: remoteStreamId, isRemoteCameraEnable: isRemoteCameraEnable, remoteAvatar: remoteAvatar, remoteName: remoteName)
            case "updateState":
                let arguments = call.arguments as? [String: Any] ?? [String: Any]()
                let isRemoteCameraEnable = arguments["isRemoteCameraEnable"] as? Bool ?? false
                WaterbusViewController.shared.updateStateUserView(result, isRemoteCameraEnable: isRemoteCameraEnable)
            case "stopPictureInPicture":
                WaterbusViewController.shared.disposePictureInPicture()
                result(true)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        gallerySaverChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping  FlutterResult)  -> Void in
            self.result = result
            if (call.method == "saveImageToGallery") {
                let arguments = call.arguments as? [String: Any] ?? [String: Any]()
                guard let imageData = (arguments["imageBytes"] as? FlutterStandardTypedData)?.data,
                      let image = UIImage(data: imageData),
                      let quality = arguments["quality"] as? Int,
                      let _ = arguments["name"],
                      let isReturnImagePath = arguments["isReturnImagePathOfIOS"] as? Bool
                else { return }
                let newImage = image.jpegData(compressionQuality: CGFloat(quality / 100))!
                self.saveImage(UIImage(data: newImage) ?? image, isReturnImagePath: isReturnImagePath)
            } else if (call.method == "saveFileToGallery") {
                guard let arguments = call.arguments as? [String: Any],
                      let path = arguments["file"] as? String,
                      let _ = arguments["name"],
                      let isReturnFilePath = arguments["isReturnPathOfIOS"] as? Bool else { return }
                if (self.isImageFile(filename: path)) {
                    self.saveImageAtFileUrl(path, isReturnImagePath: isReturnFilePath)
                } else {
                    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
                        self.saveVideo(path, isReturnImagePath: isReturnFilePath)
                    }else{
                        self.saveResult(isSuccess:false,error:self.errorMessage)
                    }
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        
        replayKitChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping  FlutterResult)  -> Void in
            self.handleReplayKitFromFlutter(result: result, call:call)
        })
        
        FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: flutterEngine)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func handleReplayKitFromFlutter(result:FlutterResult, call: FlutterMethodCall){
        switch (call.method) {
        case "closeReplayKitFromFlutter":
            let group=UserDefaults(suiteName: "group.waterbus.broadcastext")
            group!.set(true,forKey: "closeReplayKitFromFlutter")
            group!.set(false, forKey: "hasSampleBroadcast")
            return result(true)
        case "startReplayKit":
            self.hasEmittedFirstSample = false
            let group=UserDefaults(suiteName: "group.waterbus.broadcastext")
            group!.set(false, forKey: "closeReplayKitFromNative")
            group!.set(false, forKey: "closeReplayKitFromFlutter")
            group!.set(false, forKey: "hasSampleBroadcast")
            self.observeReplayKitState()
        default:
            return result(FlutterMethodNotImplemented)
        }
    }
    
    override func applicationWillEnterForeground(_ application: UIApplication) {
        WaterbusViewController.shared.stopPictureInPicture()
    }
    
    func observeReplayKitState(){
        if (self.observeTimer != nil) {
            return
        }
        
        let group=UserDefaults(suiteName: "group.waterbus.broadcastext")
        self.observeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            let closeReplayKitFromNative=group!.bool(forKey: "closeReplayKitFromNative")
            let closeReplayKitFromFlutter=group!.bool(forKey: "closeReplayKitFromFlutter")
            let hasSampleBroadcast=group!.bool(forKey: "hasSampleBroadcast")
            if (closeReplayKitFromNative) {
                self.hasEmittedFirstSample = false
                self.replayKitChannel.invokeMethod("closeReplayKitFromNative", arguments: true)
            } else if (hasSampleBroadcast) {
                if (!self.hasEmittedFirstSample) {
                    self.hasEmittedFirstSample = true
                    self.replayKitChannel.invokeMethod("hasSampleBroadcast", arguments: true)
                }
            }
        }
    }
    
    func saveVideo(_ path: String, isReturnImagePath: Bool) {
        if !isReturnImagePath {
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(didFinishSavingVideo(videoPath:error:contextInfo:)), nil)
            return
        }
        var videoIds: [String] = []
        
        PHPhotoLibrary.shared().performChanges( {
            let req = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL.init(fileURLWithPath: path))
            if let videoId = req?.placeholderForCreatedAsset?.localIdentifier {
                videoIds.append(videoId)
            }
        }, completionHandler: { [unowned self] (success, error) in
            DispatchQueue.main.async {
                if (success && videoIds.count > 0) {
                    let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: videoIds, options: nil)
                    if (assetResult.count > 0) {
                        let videoAsset = assetResult[0]
                        PHImageManager().requestAVAsset(forVideo: videoAsset, options: nil) { (avurlAsset, audioMix, info) in
                            if let urlStr = (avurlAsset as? AVURLAsset)?.url.absoluteString {
                                self.saveResult(isSuccess: true, filePath: urlStr)
                            }
                        }
                    }
                } else {
                    self.saveResult(isSuccess: false, error: self.errorMessage)
                }
            }
        })
    }
    
    func saveImage(_ image: UIImage, isReturnImagePath: Bool) {
        if !isReturnImagePath {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(didFinishSavingImage(image:error:contextInfo:)), nil)
            return
        }
        
        var imageIds: [String] = []
        
        PHPhotoLibrary.shared().performChanges( {
            let req = PHAssetChangeRequest.creationRequestForAsset(from: image)
            if let imageId = req.placeholderForCreatedAsset?.localIdentifier {
                imageIds.append(imageId)
            }
        }, completionHandler: { [unowned self] (success, error) in
            DispatchQueue.main.async {
                if (success && imageIds.count > 0) {
                    let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: imageIds, options: nil)
                    if (assetResult.count > 0) {
                        let imageAsset = assetResult[0]
                        let options = PHContentEditingInputRequestOptions()
                        options.canHandleAdjustmentData = { (adjustmeta)
                            -> Bool in true }
                        imageAsset.requestContentEditingInput(with: options) { [unowned self] (contentEditingInput, info) in
                            if let urlStr = contentEditingInput?.fullSizeImageURL?.absoluteString {
                                self.saveResult(isSuccess: true, filePath: urlStr)
                            }
                        }
                    }
                } else {
                    self.saveResult(isSuccess: false, error: self.errorMessage)
                }
            }
        })
    }
    
    func saveImageAtFileUrl(_ url: String, isReturnImagePath: Bool) {
        if !isReturnImagePath {
            if let image = UIImage(contentsOfFile: url) {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(didFinishSavingImage(image:error:contextInfo:)), nil)
            }
            return
        }
        
        var imageIds: [String] = []
        
        PHPhotoLibrary.shared().performChanges( {
            let req = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: URL(string: url)!)
            if let imageId = req?.placeholderForCreatedAsset?.localIdentifier {
                imageIds.append(imageId)
            }
        }, completionHandler: { [unowned self] (success, error) in
            DispatchQueue.main.async {
                if (success && imageIds.count > 0) {
                    let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: imageIds, options: nil)
                    if (assetResult.count > 0) {
                        let imageAsset = assetResult[0]
                        let options = PHContentEditingInputRequestOptions()
                        options.canHandleAdjustmentData = { (adjustmeta)
                            -> Bool in true }
                        imageAsset.requestContentEditingInput(with: options) { [unowned self] (contentEditingInput, info) in
                            if let urlStr = contentEditingInput?.fullSizeImageURL?.absoluteString {
                                self.saveResult(isSuccess: true, filePath: urlStr)
                            }
                        }
                    }
                } else {
                    self.saveResult(isSuccess: false, error: self.errorMessage)
                }
            }
        })
    }
    
    /// finish saving，if has error，parameters error will not nill
    @objc func didFinishSavingImage(image: UIImage, error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        saveResult(isSuccess: error == nil, error: error?.description)
    }
    
    @objc func didFinishSavingVideo(videoPath: String, error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        saveResult(isSuccess: error == nil, error: error?.description)
    }
    
    func saveResult(isSuccess: Bool, error: String? = nil, filePath: String? = nil) {
        var saveResult = SaveResultModel()
        saveResult.isSuccess = error == nil
        saveResult.errorMessage = error?.description
        saveResult.filePath = filePath
        result?(saveResult.toDic())
    }
    
    func isImageFile(filename: String) -> Bool {
        return filename.hasSuffix(".jpg")
        || filename.hasSuffix(".png")
        || filename.hasSuffix(".jpeg")
        || filename.hasSuffix(".JPEG")
        || filename.hasSuffix(".JPG")
        || filename.hasSuffix(".PNG")
        || filename.hasSuffix(".gif")
        || filename.hasSuffix(".GIF")
        || filename.hasSuffix(".heic")
        || filename.hasSuffix(".HEIC")
    }
}


public struct SaveResultModel: Encodable {
    var isSuccess: Bool!
    var filePath: String?
    var errorMessage: String?
    
    func toDic() -> [String:Any]? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else { return nil }
        if (!JSONSerialization.isValidJSONObject(data)) {
            return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
        }
        return nil
    }
}
