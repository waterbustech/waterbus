//
//  WaterbusViewController.swift
//  Runner
//
//  Created by lambiengcode on 19/11/2023.
//

import AVKit
import UIKit
import Flutter
import flutter_webrtc_plus

class WaterbusViewController: FlutterViewController {
    
    // MARK: Singleton
    static let shared = WaterbusViewController()
    
    // MARK: Public static variables
    static var pipController: AVPictureInPictureController?
    static var pipContentSource: Any?
    static var pipVideoCallViewController: Any?
    
    // MARK: Private variables
    private var pictureInPictureView: PictureInPictureView = PictureInPictureView()
    
    open override func viewDidLoad() {
        // get the flutter engine for the view
        let flutterEngine: FlutterEngine! = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        
        // add flutter view
        addFlutterView(with: flutterEngine)
        
        // configuration pip view controller
        preparePictureInPicture()
    }
    
    func preparePictureInPicture() {
        if #available(iOS 15.0, *) {
            WaterbusViewController.pipVideoCallViewController = AVPictureInPictureVideoCallViewController()
            (WaterbusViewController.pipVideoCallViewController as! AVPictureInPictureVideoCallViewController).preferredContentSize = CGSize(width: Sizer.WIDTH_OF_PIP, height: Sizer.HEIGHT_OF_PIP)
            (WaterbusViewController.pipVideoCallViewController as! AVPictureInPictureVideoCallViewController).view.clipsToBounds = true
            
            WaterbusViewController.pipContentSource = AVPictureInPictureController.ContentSource(
                activeVideoCallSourceView: self.view,
                contentViewController: (WaterbusViewController.pipVideoCallViewController as! AVPictureInPictureVideoCallViewController)
            )
        }
    }
    
    func configurationPictureInPicture(result: @escaping  FlutterResult, peerConnectionId: String, remoteStreamId: String, isRemoteCameraEnable: Bool, myAvatar: String, remoteAvatar: String, remoteName: String) {
        if #available(iOS 15.0, *) {
            if (WaterbusViewController.pipContentSource != nil) {
                WaterbusViewController.pipController = AVPictureInPictureController(contentSource: WaterbusViewController.pipContentSource as! AVPictureInPictureController.ContentSource)
                WaterbusViewController.pipController?.canStartPictureInPictureAutomaticallyFromInline = true
                WaterbusViewController.pipController?.delegate = self
                
                // Add view
                let frameOfPiP = (WaterbusViewController.pipVideoCallViewController as! AVPictureInPictureVideoCallViewController).view.frame
                pictureInPictureView = PictureInPictureView(frame: frameOfPiP)
                pictureInPictureView.contentMode = .scaleAspectFit
                pictureInPictureView.initParameters(peerConnectionId: peerConnectionId, remoteStreamId: remoteStreamId, isRemoteCameraEnable: isRemoteCameraEnable, myAvatar: myAvatar, remoteAvatar: remoteAvatar, remoteName: remoteName)
                (WaterbusViewController.pipVideoCallViewController as! AVPictureInPictureVideoCallViewController).view.addSubview(pictureInPictureView)
                
                addConstraintLayout()
            }
        }
        
        result(true)
    }
    
    func addConstraintLayout() {
        if #available(iOS 15.0, *) {
            pictureInPictureView.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                pictureInPictureView.leadingAnchor.constraint(equalTo: (WaterbusViewController.pipVideoCallViewController as! AVPictureInPictureVideoCallViewController).view.leadingAnchor),
                pictureInPictureView.trailingAnchor.constraint(equalTo: (WaterbusViewController.pipVideoCallViewController as! AVPictureInPictureVideoCallViewController).view.trailingAnchor),
                pictureInPictureView.topAnchor.constraint(equalTo: (WaterbusViewController.pipVideoCallViewController as! AVPictureInPictureVideoCallViewController).view.topAnchor),
                pictureInPictureView.bottomAnchor.constraint(equalTo: (WaterbusViewController.pipVideoCallViewController as! AVPictureInPictureVideoCallViewController).view.bottomAnchor)
            ]
            (WaterbusViewController.pipVideoCallViewController as! AVPictureInPictureVideoCallViewController).view.addConstraints(constraints)
            pictureInPictureView.bounds = (WaterbusViewController.pipVideoCallViewController as! AVPictureInPictureVideoCallViewController).view.frame
        }
    }
    
    func updatePictureInPictureView(_ result: @escaping FlutterResult, peerConnectionId: String, remoteStreamId: String, isRemoteCameraEnable: Bool, remoteAvatar: String, remoteName: String) {
        pictureInPictureView.setRemoteInfo(peerConnectionId: peerConnectionId, remoteStreamId: remoteStreamId, isRemoteCameraEnable: isRemoteCameraEnable, remoteAvatar: remoteAvatar, remoteName: remoteName)
        result(true)
    }
    
    func updateStateUserView(_ result: @escaping FlutterResult, isRemoteCameraEnable: Bool) {
        pictureInPictureView.updateStateValue(isRemoteCameraEnable: isRemoteCameraEnable)
        result(true)
    }
    
    func disposePictureInPicture() {
        // MARK: reset
        pictureInPictureView.disposeVideoView()
        
        if #available(iOS 15.0, *) {
            (WaterbusViewController.pipVideoCallViewController as! AVPictureInPictureVideoCallViewController).view.removeAllSubviews()
        }
        
        if (WaterbusViewController.pipController == nil) {
            return
        }
        
        WaterbusViewController.pipController = nil
    }
    
    func stopPictureInPicture() {
        if #available(iOS 15.0, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                WaterbusViewController.pipController?.stopPictureInPicture()
            }
        }
    }
}

extension WaterbusViewController: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print(">> pictureInPictureControllerWillStopPictureInPicture")
        self.pictureInPictureView.stopPictureInPictureView()
    }
    
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print(">> pictureInPictureControllerWillStartPictureInPicture")
        self.pictureInPictureView.updateLayoutVideoVideo()
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        print("Unable start pip error:", error.localizedDescription)
    }
}

// create an extension for all UIViewControllers
extension UIViewController {
    /**
     Add a flutter sub view to the UIViewController
     sets constraints to edge to edge, covering all components on the screen
     */
    func addFlutterView(with engine: FlutterEngine) {
        // create the flutter view controller
        let flutterViewController = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        
        addChild(flutterViewController)
        
        guard let flutterView = flutterViewController.view else { return }
        
        // allows constraint manipulation
        flutterView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(flutterView)
        
        // set the constraints (edge-to-edge) to the flutter view
        let constraints = [
            flutterView.topAnchor.constraint(equalTo: view.topAnchor),
            flutterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            flutterView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            flutterView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        // apply (activate) the constraints
        NSLayoutConstraint.activate(constraints)
        
        flutterViewController.didMove(toParent: self)
        
        // updates the view with configured layout
        flutterView.layoutIfNeeded()
    }
}
