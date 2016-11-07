//
//  PostsVCLayouts.swift
//  ChatHook8
//
//  Created by Kevin Farm on 10/15/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit

extension PostsVC{
    //MARK: - Setup Methods
    func setupNavBarWithUserOrProgress(progress:String?){
        
        let titleView = topView
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.layer.cornerRadius = 15
            profileImageView.clipsToBounds = true
            profileImageView.image = messageImage
        
        containerView.addSubview(profileImageView)
        
        profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let nameLabel = UILabel()
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.font = UIFont(name: FONT_AVENIR_MEDIUM, size: 14.0)
        
        if let progressText = progress{
            nameLabel.text = "Upload: \(progressText)"
            nameLabel.textColor = UIColor.red
        }else{
            nameLabel.text = parentRoom?.RoomName
            nameLabel.textColor = UIColor.darkGray
        }
        
        containerView.addSubview(nameLabel)
        
        nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    func setupTopView(){
        //need x, y, width and height constraints
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 72).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        topView.addSubview(postTextField)
        topView.addSubview(imageSelectorView)
        topView.addSubview(postButton)
        
        postTextField.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 8).isActive = true
        postTextField.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        postTextField.widthAnchor.constraint(equalToConstant: 225).isActive = true
        postTextField.heightAnchor.constraint(equalTo: topView.heightAnchor, constant: -16).isActive = true
        
        imageSelectorView.leftAnchor.constraint(equalTo: postTextField.rightAnchor, constant: 8).isActive = true
        imageSelectorView.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        imageSelectorView.widthAnchor.constraint(equalToConstant: 37).isActive = true
        imageSelectorView.heightAnchor.constraint(equalTo: topView.heightAnchor, constant: -16).isActive = true
        
        postButton.leftAnchor.constraint(equalTo: imageSelectorView.rightAnchor, constant: 8).isActive = true
        postButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        postButton.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -8).isActive = true
        postButton.heightAnchor.constraint(equalTo: topView.heightAnchor, constant: -16).isActive = true
    }
    
    func setupPostTableView(){
        postTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postTableView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8).isActive = true
        postTableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        postTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
    }
 
}
