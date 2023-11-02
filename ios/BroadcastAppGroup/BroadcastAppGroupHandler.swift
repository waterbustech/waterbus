//
//  BroadcastAppGroupHandler.swift
//  Runner
//
//  Created by lambiengcode on 02/11/2023.
//

import Foundation
import ReplayKit
class BroadcastAppGroupHandler:NSObject {

    func checkForClosing(sampleHandler:RPBroadcastSampleHandler){
        let group=UserDefaults(suiteName: "group.waterbus.broadcastext")
        let closeReplayKitFromFlutter=group!.bool(forKey: "closeReplayKitFromFlutter")
        if(closeReplayKitFromFlutter){
            let userInfo = [NSLocalizedFailureReasonErrorKey: "Call Ended"]
            sampleHandler.finishBroadcastWithError(NSError(domain: "ScreenShare", code: -1, userInfo: userInfo)
            )
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            self.checkForClosing(sampleHandler:sampleHandler)
        }
    
    }
    func startBroadcast(sampleHandler:RPBroadcastSampleHandler){
        self.checkForClosing(sampleHandler:sampleHandler)
    }
 
}
