//
//  ProfileVCLayouts.swift
//  ChatHook8
//
//  Created by Kevin Farm on 10/26/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit

extension ProfileViewController{
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView!.allowsMultipleSelection = editing
        
        let indexPaths = collectionView!.indexPathsForVisibleItems as [NSIndexPath]
        for indexPath in indexPaths{
            collectionView!.deselectItem(at: indexPath as IndexPath, animated: false)
            let cell = collectionView!.cellForItem(at: indexPath as IndexPath) as! GalleryCollectionCell
            cell.editing = editing
        }
        
        if !editing{
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func setupCollectionView(){
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupMainView(){
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        view.addSubview(backgroundImageView)
        view.addSubview(addPhotoButton)
        view.addSubview(blockButton)
        view.addSubview(profileChatButton)
        
        if selectedUser != nil{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        }else{
            navigationItem.leftBarButtonItem = editButtonItem
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.itemSize = CGSize(width: screenWidth / 5, height: 120)
        
        let frame = CGRect(x: 0, y: view.center.y, width: view.frame.width, height: view.frame.height / 2 - 44)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        collectionView.addSubview(addPhotosToGalleryLabel)
        
        addPhotosToGalleryLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        addPhotosToGalleryLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
        
        self.view.addSubview(collectionView)
    }
    
    func setupBackgroundImageView(){
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        backgroundImageView.addSubview(profileImageView)
        backgroundImageView.addSubview(currentUserNameLabel)
        backgroundImageView.addSubview(distanceLabel)
        
        profileImageView.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        currentUserNameLabel.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor).isActive = true
        currentUserNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        
        distanceLabel.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: currentUserNameLabel.bottomAnchor, constant: 8).isActive = true
        
        addPhotoButton.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        addPhotoButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        addPhotoButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addPhotoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        blockButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        blockButton.bottomAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 8).isActive = true
        blockButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        blockButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        profileChatButton.rightAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: -8).isActive = true
        profileChatButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        profileChatButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        profileChatButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
    }
    
    func setupSelectedUserProfile(){
        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: (self.selectedUser?.profileImageUrl)!)
        self.currentUserNameLabel.text = self.selectedUser?.userName
        if let stringDistance = self.selectedUser?.distance {
            let unwrappedString = String(format: "%.2f", (stringDistance))
            self.distanceLabel.text = "\(unwrappedString) miles away"
        }
        self.navigationItem.title = self.selectedUser?.userName
    }
}
