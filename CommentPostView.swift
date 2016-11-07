//
//  CommentPostView.swift
//  ChatHook
//
//  Created by Kevin Farm on 8/24/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit
import Firebase

class CommentPostView: MaterialView {
    var postViewController:PostsVC?
    var likeRef: FIRDatabaseReference!
    
    var userPost: UserPost?{
        didSet{
            self.profileImageView.loadImageUsingCacheWithUrlString(urlString: (userPost?.authorPic!)!)
            self.userNameLabel.text = userPost?.authorName
            self.descriptionText.text = userPost?.postText
            self.cityAndStateLabel.text = userPost?.cityAndState
            
            
            if userPost?.mediaType == "PHOTO"{
                if let showCaseImageURL = userPost?.showcaseUrl{
                    self.showcaseImageView.loadImageUsingCacheWithUrlString(urlString: showCaseImageURL)
                }
            }
            
            if userPost?.mediaType == "VIDEO"{
                if let thumbNailURL = userPost?.thumbnailUrl{
                    self.showcaseImageView.loadImageUsingCacheWithUrlString(urlString: thumbNailURL)
                }
            }
            
            if let seconds = userPost?.timestamp?.doubleValue{
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM d, hh:mm a"
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
        }
    }
    
    var postLiked: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let cellContainerView: UIView = {
        let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.backgroundColor = UIColor.white
            containerView.layer.cornerRadius = 5.0
            containerView.layer.masksToBounds = true
            containerView.sizeToFit()
        return containerView
    }()
    
    lazy var profilePictureUserNameContainerView: UIView = {
        let profileNameView = UIView()
            profileNameView.translatesAutoresizingMaskIntoConstraints = false
            profileNameView.backgroundColor = UIColor.white
            profileNameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(testPostCell.handleProfileViewTapped)))
        return profileNameView
    }()
    
    let profileImageView: MaterialImageView = {
        let imageView = MaterialImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 24
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.alpha = 1.0
            label.text = "User Name"
            label.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  18.0)
            label.backgroundColor = UIColor.clear
            label.textColor = UIColor.blue
            label.sizeToFit()
        return label
    }()
    
    let cityAndStateLabel: UILabel = {
        let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: FONT_AVENIR_LIGHT, size:  12.0)
            label.backgroundColor = UIColor.clear
            label.textColor = UIColor.lightGray
            label.sizeToFit()
        return label
    }()
    
    lazy var likeButton: UIButton = {
        let likeBtn = UIButton()
        let image = UIImage(named: "Like")
            likeBtn.setImage(image, for: .normal)
            likeBtn.translatesAutoresizingMaskIntoConstraints = false
            //likeBtn.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
        return likeBtn
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor.lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
        return label
    }()
    
    var likeCount: UILabel = {
        let label = UILabel()
            label.text = "0"
            label.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  12.0)
            label.textColor = UIColor.darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
        return label
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
            label.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  12.0)
            label.textColor = UIColor.darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
        return label
    }()
    
    let descriptionText: UILabel = {
        let descripTextView = UILabel()
            descripTextView.translatesAutoresizingMaskIntoConstraints = false
            descripTextView.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  14.0)
            descripTextView.textColor = UIColor.darkGray
            descripTextView.numberOfLines = 0
        return descripTextView
    }()
    
    lazy var showcaseImageView: UIImageView = {
        let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 5
            imageView.layer.masksToBounds = true
            imageView.layer.shadowOpacity = 0.8
            imageView.layer.shadowRadius = 5.0
            imageView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            imageView.layer.shadowColor = UIColor.black.cgColor
        return imageView
    }()
    
    let separatorLineView: UIView = {
        let sepLineView = UIView()
            sepLineView.translatesAutoresizingMaskIntoConstraints = false
            sepLineView.backgroundColor = UIColor.darkGray
        return sepLineView
    }()
    
    let commentContainerView: UIView = {
        let commentContainerView = UIView()
            commentContainerView.translatesAutoresizingMaskIntoConstraints = false
            commentContainerView.backgroundColor = UIColor.white
        return commentContainerView
    }()
    
    var commentCount: UILabel = {
        let label = UILabel()
            label.text = "0"
            label.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  12.0)
            label.textColor = UIColor.darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
            label.text = "Comments"
            label.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  12.0)
            label.textColor = UIColor.darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        addSubview(profilePictureUserNameContainerView)
        addSubview(descriptionText)
        addSubview(showcaseImageView)
        setupCellContainerView()
    }
    
    func setupCellContainerView(){
        //cellContainerView.addSubview(profilePictureUserNameContainerView)
        profilePictureUserNameContainerView.addSubview(profileImageView)
        profilePictureUserNameContainerView.addSubview(userNameLabel)
        profilePictureUserNameContainerView.addSubview(cityAndStateLabel)
        profilePictureUserNameContainerView.addSubview(timeLabel)
        
        
        profilePictureUserNameContainerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profilePictureUserNameContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        profilePictureUserNameContainerView.widthAnchor.constraint(equalToConstant: 235).isActive = true
        profilePictureUserNameContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: profilePictureUserNameContainerView.leftAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: profilePictureUserNameContainerView.topAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        userNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        userNameLabel.centerYAnchor.constraint(equalTo: profilePictureUserNameContainerView.centerYAnchor, constant: -8).isActive = true
        
        cityAndStateLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        cityAndStateLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: -4).isActive = true
        
        timeLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        timeLabel.topAnchor.constraint(equalTo: cityAndStateLabel.bottomAnchor, constant: -4).isActive = true
        
        descriptionText.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        descriptionText.topAnchor.constraint(equalTo: profilePictureUserNameContainerView.bottomAnchor).isActive = true
        descriptionText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -16).isActive = true
        descriptionText.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        showcaseImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        showcaseImageView.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: -8).isActive = true
        showcaseImageView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -16).isActive = true
        showcaseImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
    }
    
    func handleProfileViewTapped(tapGesture: UITapGestureRecognizer){
        postViewController?.handleProfile(profileView: tapGesture.view!)
    }
}

//extension testPostCell: UITextViewDelegate{
//    func textViewDidChange(textView: UITextView) {
//        let fixedWidth = textView.frame.size.width
//        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
//        var newFrame = textView.frame
//        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//        textView.frame = newFrame;
//    }
//}

