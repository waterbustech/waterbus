import UIKit
import Flutter
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
    var flutterEngine = FlutterEngine(name: "FlutterEngine")
    var replayKitChannel: FlutterMethodChannel! = nil
    var observeTimer: Timer?
    var hasEmittedFirstSample = false
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        flutterEngine.run()
        
        let controller =
        FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        
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
}
