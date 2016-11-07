//
//  UserCell.swift
//  ChatHook
//
//  Created by Kevin Farm on 8/22/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit
import Firebase



class UserCell: UITableViewCell {
    var message: Message?{
        didSet{
            setupNameAndProfileImage()
            if message?.text != nil{
               detailTextLabel?.text = message?.text
            }else{
                if message?.mediaType == "PHOTO"{
                    detailTextLabel?.text = "Photo sent"
                }else if message?.mediaType == "VIDEO"{
                    detailTextLabel?.text = "Video sent"
                }
            }
            timeLabel.text = formatDate(messageTimeStamp: (message?.timestamp?.doubleValue)!)
            if let didIBlockThisUser = CurrentUser._blockedUsersArray?.contains((message?.chatPartnerID()!)!){
                message?.isFromBlockedUser = didIBlockThisUser
                blockedUserContainerView.isHidden = !didIBlockThisUser
            }
        }
    }
    
    lazy var blockedUserContainerView: UIView = {
        let profileNameView = UIView()
            profileNameView.translatesAutoresizingMaskIntoConstraints = false
            profileNameView.backgroundColor = UIColor.clear
        
        return profileNameView
    }()
    
    let blockedUserImageView: MaterialImageView = {
        let blockedImage = UIImage(named: "blocker")
        let imageView = MaterialImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 24
            imageView.layer.masksToBounds = true
            imageView.image = blockedImage
            imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let blockedLabel: UILabel = {
        let label = UILabel()
            label.text = "Blocked"
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  12.0)
            label.textColor = UIColor.red
            label.sizeToFit()
        return label
    }()

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 24
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let onlineImageView: UIImageView = {
        let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 10
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor.lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .right
            label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(onlineImageView)
        addSubview(timeLabel)
        addSubview(blockedUserContainerView)
        layoutUserCell()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        detailTextLabel?.textColor = UIColor.lightGray
    }

    func layoutUserCell(){
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        onlineImageView.centerXAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: 7).isActive = true
        onlineImageView.centerYAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 7).isActive = true
        onlineImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        onlineImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        
        blockedUserContainerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 64).isActive = true
        blockedUserContainerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        blockedUserContainerView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        blockedUserContainerView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        blockedUserContainerView.addSubview(blockedUserImageView)
        blockedUserContainerView.addSubview(blockedLabel)
        
        blockedUserImageView.leftAnchor.constraint(equalTo: blockedUserContainerView.leftAnchor).isActive = true
        blockedUserImageView.centerYAnchor.constraint(equalTo: blockedUserContainerView.centerYAnchor).isActive = true
        blockedUserImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        blockedUserImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        blockedLabel.rightAnchor.constraint(equalTo: blockedUserContainerView.rightAnchor).isActive = true
        blockedLabel.centerYAnchor.constraint(equalTo: blockedUserContainerView.centerYAnchor).isActive = true
        blockedLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        blockedLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func addBlockedContainer(){
        
    }
    
    private func formatDate(messageTimeStamp: Double) -> String{
        let timestampDate = NSDate(timeIntervalSince1970: messageTimeStamp)
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, hh:mm a"
        return dateFormatter.string(from: timestampDate as Date)
    }
    
    private func setupNameAndProfileImage(){
        if let id = message?.chatPartnerID(){
            checkIfUserIsOnline(userID: id)
            let getUserFromChatPartnerID = DataService.ds.REF_USERS.child(id)
            getUserFromChatPartnerID.observeSingleEvent(of: .value, with: { (snapshot) in
                if let userInfoDict = snapshot.value as? [String: AnyObject]{
                    self.textLabel?.text = userInfoDict["UserName"] as? String
                    if let profileImageUrl = userInfoDict["ProfileImage"] as? String{
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
            }, withCancel: nil)
        }
    }
    
    func checkIfUserIsOnline(userID: String){
        let searchLat = Int(CurrentUser._location.coordinate.latitude)
        let searchLong = Int(CurrentUser._location.coordinate.longitude)
        let onlineRef = DataService.ds.REF_USERSONLINE.child("\(searchLat)").child("\(searchLong)").child(userID)
        
        onlineRef.observeSingleEvent(of: .value, with: { snapshot in
            if let _ = snapshot.value as? NSNull{
                let image = UIImage(named: "offline")
                self.onlineImageView.image = image
            }else{
                let image = UIImage(named: "online")
                self.onlineImageView.image = image

            }
        })
    }
}//end user cell
