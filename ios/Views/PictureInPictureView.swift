//
//  PictureInPictureView.swift
//  Runner
//
//  Created by lambiengcode on 19/11/2023.
//

import UIKit
import AVKit
import flutter_webrtc

class PictureInPictureView: UIView {
    // MARK: Private
    private var myUserNameCard: UserView = UserView()
    private var remoteUserNameCard: UserView = UserView()
    private var localView: UIView = UIView()
    private var remoteView: UIView = UIView()
    private var remoteRenderer: RTCMTLVideoView? = nil
    private var peerConnectionId: String? = nil
    private var remoteStreamId: String? = nil
    private var isLocalCameraEnable: Bool = false
    private var isRemoteCameraEnable: Bool = false
    
    private var pictureInPictureIsRunning: Bool = false
    
    // MARK: Funcs
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        // MARK: Setup subviews
        localView = UIView()
        localView.clipsToBounds = true
        remoteView = UIView()
        remoteView.clipsToBounds = true
        
        // MARK: add to parent view
        addSubview(localView)
        addSubview(remoteView)
        configurationLayoutConstrains()
        
        // MARK: add user card view to subviews
        self.addAvatarView()
        self.configurationLayoutConstraintUserNameCard()
    }
    
    func addAvatarView() {
        // Add local and remote avatar
        myUserNameCard = UserView()
        myUserNameCard.setUserName(userName: "You")
        myUserNameCard.contentMode = .scaleAspectFit
        localView.addSubview(myUserNameCard)
        
        remoteUserNameCard = UserView()
        remoteUserNameCard.contentMode = .scaleAspectFit
        remoteView.addSubview(remoteUserNameCard)
    }
    
    func initParameters(peerConnectionId: String, remoteStreamId: String, isRemoteCameraEnable: Bool, myAvatar: String, remoteAvatar: String, remoteName: String) {
        self.myUserNameCard.setAvatar(avatar: myAvatar)
        
        self.setRemoteInfo(peerConnectionId: peerConnectionId, remoteStreamId: remoteStreamId, isRemoteCameraEnable: isRemoteCameraEnable, remoteAvatar: remoteAvatar, remoteName: remoteName)
    }
    
    func setRemoteInfo(peerConnectionId: String, remoteStreamId: String, isRemoteCameraEnable: Bool, remoteAvatar: String, remoteName: String) {
        self.remoteStreamId = remoteStreamId
        self.isRemoteCameraEnable = isRemoteCameraEnable
        self.remoteUserNameCard.setAvatar(avatar: remoteAvatar)
        self.remoteUserNameCard.setUserName(userName: remoteName)
    }
    
    func updateStateValue(isRemoteCameraEnable: Bool) {
        if (self.isRemoteCameraEnable != isRemoteCameraEnable) {
            self.isRemoteCameraEnable = isRemoteCameraEnable
            
            if (!self.pictureInPictureIsRunning) {
                return
            }
            
            if (self.isRemoteCameraEnable) {
                self.addRemoteRendererToView()
            } else {
                self.remoteRenderer?.removeFromSuperview()
            }
        }
    }
    
    func configurationLayoutConstrains() {
        // Enable Autolayout
        localView.translatesAutoresizingMaskIntoConstraints = false
        remoteView.translatesAutoresizingMaskIntoConstraints = false
        
        localView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        localView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        localView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        localView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        remoteView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        remoteView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        remoteView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        remoteView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func configurationLayoutConstraintForRenderer() {
        if (self.remoteRenderer == nil) {
            return
        }
        
        self.remoteRenderer!.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.remoteRenderer!.leadingAnchor.constraint(equalTo: remoteView.leadingAnchor),
            self.remoteRenderer!.trailingAnchor.constraint(equalTo: remoteView.trailingAnchor),
            self.remoteRenderer!.topAnchor.constraint(equalTo: remoteView.topAnchor),
            self.remoteRenderer!.bottomAnchor.constraint(equalTo: remoteView.bottomAnchor)
        ]
        self.remoteView.addConstraints(constraints)
        self.remoteRenderer!.bounds = self.remoteView.frame
    }
    
    func configurationLayoutConstraintUserNameCard() {
        myUserNameCard.translatesAutoresizingMaskIntoConstraints = false
        remoteUserNameCard.translatesAutoresizingMaskIntoConstraints = false
        
        let constraintsLocal = [
            self.myUserNameCard.leadingAnchor.constraint(equalTo: localView.leadingAnchor),
            self.myUserNameCard.trailingAnchor.constraint(equalTo: localView.trailingAnchor),
            self.myUserNameCard.topAnchor.constraint(equalTo: localView.topAnchor),
            self.myUserNameCard.bottomAnchor.constraint(equalTo: localView.bottomAnchor)
        ]
        let constraintsRemote = [
            self.remoteUserNameCard.leadingAnchor.constraint(equalTo: remoteView.leadingAnchor),
            self.remoteUserNameCard.trailingAnchor.constraint(equalTo: remoteView.trailingAnchor),
            self.remoteUserNameCard.topAnchor.constraint(equalTo: remoteView.topAnchor),
            self.remoteUserNameCard.bottomAnchor.constraint(equalTo: remoteView.bottomAnchor)
        ]
        self.localView.addConstraints(constraintsLocal)
        self.remoteView.addConstraints(constraintsRemote)
        self.myUserNameCard.bounds = self.localView.frame
        self.remoteUserNameCard.bounds = self.remoteView.frame
    }
    
    func configurationVideoView() {
        if (remoteStreamId == nil || peerConnectionId == nil) {
            return
        }
        
        if #available(iOS 15.0, *) {
            // Remote
            if (self.isRemoteCameraEnable) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.addRemoteRendererToView()
                }
            }
        }
    }
    
    func addRemoteRendererToView() {
        self.remoteRenderer = RTCMTLVideoView()
        self.remoteRenderer!.contentMode = .scaleAspectFit
        self.remoteRenderer!.videoContentMode = .scaleAspectFill
        
        // Get RemoteMTLVideoView
        let mediaRemoteStream = FlutterWebRTCPlugin.sharedSingleton().stream(forId: self.remoteStreamId, peerConnectionId: self.peerConnectionId)
        mediaRemoteStream?.videoTracks.first?.add(self.remoteRenderer!)
        
        self.remoteView.addSubview(self.remoteRenderer!)
        self.configurationLayoutConstraintForRenderer()
    }
    
    func updateLayoutVideoVideo() {
        self.stopPictureInPictureView()
        
        self.pictureInPictureIsRunning = true
        self.myUserNameCard.isHidden = false
        self.remoteUserNameCard.isHidden = false
        
        // MARK: add video view
        self.configurationVideoView()
    }
    
    
    // MARK: release variables
    func disposeVideoView() {
        remoteStreamId = nil
        peerConnectionId = nil
    }
    
    func stopPictureInPictureView() {
        self.pictureInPictureIsRunning = false
        self.myUserNameCard.isHidden = true
        self.remoteUserNameCard.isHidden = true
        self.remoteRenderer?.removeFromSuperview()
    }
}
