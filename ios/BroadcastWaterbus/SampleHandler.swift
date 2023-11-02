//
//  SampleHandler.swift
//  BroadcastWaterbus
//
//  Created by lambiengcode on 02/11/2023.
//

import ReplayKit

private enum Constants {
    // the App Group ID value that the app and the broadcast extension targets are setup with. It differs for each app.
    static let appGroupIdentifier = "group.waterbus.broadcastext"
    static let thresholdFrames = 3
}

class SampleHandler: RPBroadcastSampleHandler {
    
    private var clientConnection: SocketConnection?
    private var uploader: SampleUploader?
    
    private var frameCount: Int = 0
    
    var socketFilePath: String {
        let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.appGroupIdentifier)
        return sharedContainer?.appendingPathComponent("rtc_SSFD").path ?? ""
    }
    
    override init() {
        super.init()
        if let connection = SocketConnection(filePath: socketFilePath) {
            clientConnection = connection
            setupConnection()
            
            uploader = SampleUploader(connection: connection)
        }
    }
    
    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        frameCount = 0
        
        DarwinNotificationCenter.shared.postNotification(.broadcastStarted)
        openConnection()
        
        // Vendor App Handle
        BroadcastAppGroupHandler().startBroadcast(sampleHandler: self)
        startReplayKit()
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override func broadcastFinished() {
        // User has requested to finish the broadcast.
        DarwinNotificationCenter.shared.postNotification(.broadcastStopped)
        clientConnection?.close()
        closeReplayKit()
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            ///  very simple mechanism for adjusting frame rate by using every [thresholdFrames] frame
            frameCount += 1
            if frameCount % Constants.thresholdFrames == 0 {
                uploader?.send(sample: sampleBuffer)
            }
        default:
            break
        }
    }
}

private extension SampleHandler {
    
    func setupConnection() {
        clientConnection?.didClose = { [weak self] error in
            if let error = error {
                self?.finishBroadcastWithError(error)
            } else {
                // the displayed failure message is more user friendly when using NSError instead of Error
                let JMScreenSharingStopped = 10001
                let customError = NSError(domain: RPRecordingErrorDomain, code: JMScreenSharingStopped, userInfo: [NSLocalizedDescriptionKey: "Screen sharing stopped"])
                self?.finishBroadcastWithError(customError)
            }
            let group = UserDefaults(suiteName: Constants.appGroupIdentifier)
            group!.set(true, forKey:"closeReplayKitFromNative")
            group!.set(false, forKey: "hasSampleBroadcast")
        }
    }
    
    func openConnection() {
        let queue = DispatchQueue(label: "broadcast.connectTimer")
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now(), repeating: .milliseconds(100), leeway: .milliseconds(500))
        timer.setEventHandler { [weak self] in
            guard self?.clientConnection?.open() == true else {
                return
            }
            
            timer.cancel()
        }
        
        timer.resume()
    }
    
    func startReplayKit() {
        let group=UserDefaults(suiteName: Constants.appGroupIdentifier)
        group!.set(false, forKey: "closeReplayKitFromNative")
        group!.set(false, forKey: "closeReplayKitFromFlutter")
        group!.set(true, forKey: "hasSampleBroadcast")
    }
    
    func closeReplayKit() {
        let group = UserDefaults(suiteName: Constants.appGroupIdentifier)
        group!.set(true, forKey:"closeReplayKitFromNative")
        group!.set(false, forKey: "hasSampleBroadcast")
    }
}
