//
//  UserView.swift
//  Runner
//
//  Created by lambiengcode on 19/11/2023.
//

import UIKit

class UserView: UIView {
    private var userName: UILabel = UILabel()
    private var avatar: UIImageView = UIImageView()
    
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUserName(userName: String) {
        self.userName.text = userName
    }
    
    func setAvatar(avatar: String) {
        if (!avatar.isEmpty) {
            let url = URL(string: avatar)
            if (url != nil) {
                self.downloadImage(from: url!)
            }
        }
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() {
                self.avatar.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Text
        userName.font = .systemFont(ofSize: bounds.width / 14, weight: .heavy)
        
        // Avatar
        avatar.layer.borderWidth = avatar.frame.width / 180
        avatar.layer.masksToBounds = false
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.clipsToBounds = true
    }
    
    // MARK: make view
    func setupView() {
        // MARK: username
        userName = UILabel()
        userName.numberOfLines = 1
        userName.adjustsFontSizeToFitWidth = true
        userName.minimumScaleFactor = 0.5
        userName.textAlignment = .left
        userName.textColor = .white
        
        // MARK: avatar
        avatar = UIImageView()
        avatar.contentMode = .scaleAspectFit
        avatar.image = UIImage(named: "waterbus_logo")
        
        addSubview(avatar)
        addSubview(userName)
        
        self.addLayoutConstraint()
    }
    
    func addLayoutConstraint() {
        avatar.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        
        userName.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        userName.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        userName.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.935).isActive = true
        userName.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15).isActive = true
        
        avatar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.28).isActive = true
        avatar.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.28).isActive = true
        addConstraint(NSLayoutConstraint(item: avatar, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: avatar, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
