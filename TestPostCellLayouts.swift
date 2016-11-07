//
//  TestPostCellLayouts.swift
//  ChatHook8
//
//  Created by Kevin Farm on 10/28/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit

extension testPostCell{
    //MARK: - Setup Methods
    func setupCellContainerView(){
        cellContainerView.addSubview(profilePictureUserNameContainerView)
        profilePictureUserNameContainerView.addSubview(profileImageView)
        profilePictureUserNameContainerView.addSubview(userNameLabel)
        cellContainerView.addSubview(deleteButton)
        cellContainerView.addSubview(descriptionText)
        cellContainerView.addSubview(showcaseImageView)
        cellContainerView.addSubview(likesLabel)
        cellContainerView.addSubview(separatorLineView)
        cellContainerView.addSubview(likeButton1)
        cellContainerView.addSubview(commentButton)
        cellContainerView.addSubview(shareButton)
    }
    
    func setupProfileImageUserNameLikes(){
        print("Inside setupProfileBaboon")
        print("The userPost.fromID is: \(userPost?.fromId) and the Current User PostKey is: \(CurrentUser._postKey)")
        profilePictureUserNameContainerView.leftAnchor.constraint(equalTo: cellContainerView.leftAnchor, constant: 8).isActive = true
        profilePictureUserNameContainerView.topAnchor.constraint(equalTo: cellContainerView.topAnchor, constant: 8).isActive = true
        profilePictureUserNameContainerView.widthAnchor.constraint(equalToConstant: 235).isActive = true
        profilePictureUserNameContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: profilePictureUserNameContainerView.leftAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: profilePictureUserNameContainerView.topAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        userNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: profilePictureUserNameContainerView.topAnchor).isActive = true
        
        deleteButton.rightAnchor.constraint(equalTo: cellContainerView.rightAnchor).isActive = true
        deleteButton.topAnchor.constraint(equalTo: cellContainerView.topAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupDescriptionTextShowcaseImage(){
        descriptionText.centerXAnchor.constraint(equalTo: cellContainerView.centerXAnchor).isActive = true
        descriptionText.topAnchor.constraint(equalTo: profilePictureUserNameContainerView.bottomAnchor).isActive = true
        descriptionText.widthAnchor.constraint(equalTo: cellContainerView.widthAnchor, constant: -16).isActive = true
        
        let sizeThatShouldFitTheContent = descriptionText.sizeThatFits(descriptionText.frame.size)
        print("The height of the descrip text is: \(sizeThatShouldFitTheContent.height)")
        
        
        showcaseImageView.centerXAnchor.constraint(equalTo: cellContainerView.centerXAnchor).isActive = true
        showcaseImageView.topAnchor.constraint(equalTo: descriptionText.bottomAnchor).isActive = true
        showcaseImageView.widthAnchor.constraint(equalTo: cellContainerView.widthAnchor, constant: -16).isActive = true
        showcaseImageView.heightAnchor.constraint(equalToConstant: 205).isActive = true
        
        
        contentView.addSubview(cellContainerView)
        
        cellContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        cellContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        cellContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16).isActive = true
        cellContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -16).isActive = true
    }
    
    func setupCommentSection(){
        likesLabel.leftAnchor.constraint(equalTo: cellContainerView.leftAnchor, constant: 8).isActive = true
        likesLabel.bottomAnchor.constraint(equalTo: separatorLineView.topAnchor, constant: -4).isActive = true
        
        separatorLineView.leftAnchor.constraint(equalTo: cellContainerView.leftAnchor).isActive = true
        separatorLineView.bottomAnchor.constraint(equalTo: cellContainerView.bottomAnchor, constant: -24).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: cellContainerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        likeButton1.leftAnchor.constraint(equalTo: cellContainerView.leftAnchor, constant: 8).isActive = true
        likeButton1.topAnchor.constraint(equalTo: separatorLineView.bottomAnchor, constant: 4).isActive = true
        likeButton1.widthAnchor.constraint(equalToConstant: 60).isActive = true
        likeButton1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        commentButton.centerXAnchor.constraint(equalTo: cellContainerView.centerXAnchor).isActive = true
        commentButton.topAnchor.constraint(equalTo: separatorLineView.bottomAnchor, constant: 4).isActive = true
        commentButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        shareButton.rightAnchor.constraint(equalTo: cellContainerView.rightAnchor, constant: -8).isActive = true
        shareButton.topAnchor.constraint(equalTo: separatorLineView.bottomAnchor, constant: 4).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupVideoPostCell(){
        showcaseImageView.addSubview(activityIndicator)
        showcaseImageView.addSubview(playButton)
        
        playButton.centerXAnchor.constraint(equalTo: self.showcaseImageView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: self.showcaseImageView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: self.showcaseImageView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.showcaseImageView.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    
    func setupStatusImageViewLoader() {
        loader.hidesWhenStopped = true
        loader.startAnimating()
        loader.color = UIColor.black
        self.showcaseImageView.addSubview(loader)
        loader.centerXAnchor.constraint(equalTo: self.showcaseImageView.centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: self.showcaseImageView.centerYAnchor).isActive = true
        loader.widthAnchor.constraint(equalToConstant: 50).isActive = true
        loader.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}

