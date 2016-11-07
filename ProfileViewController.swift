//
//  ProfileViewController.swift
//  ChatHook
//
//  Created by Kevin Farm on 9/12/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase
import FirebaseStorage
import AVFoundation
import AVKit

class ProfileViewController: UIViewController {
    var collectionView: UICollectionView!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var photoChoice: String?
    var galleryArray = [GalleryImage]()
    var timer: Timer?
    var selectedUser: User?
    var amIBlocked: Bool?
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingView: UIView?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    //MARK: - Properties
    let backgroundImageView: UIImageView = {
        let backImageView = UIImageView()
            backImageView.translatesAutoresizingMaskIntoConstraints = false
            backImageView.image = UIImage(named: "background1")
            backImageView.contentMode = .scaleAspectFill
        return backImageView
    }()
    
    let addPhotoButton: UIButton = {
        let addPicBtn = UIButton()
            addPicBtn.translatesAutoresizingMaskIntoConstraints = false
        return addPicBtn
    }()
    
    let blockButton: UIButton = {
        let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
            button.setTitleColor(UIColor.lightGray, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    lazy var profileChatButton: UIButton = {
        let btnImage = UIImage(named: "chatIconRev")
        let profChatButton = UIButton()
            profChatButton.translatesAutoresizingMaskIntoConstraints = false
            profChatButton.setImage(btnImage, for: .normal)
            profChatButton.addTarget(self, action: #selector(ProfileViewController.handleShowChatControllerForSelectedUser), for: .touchUpInside)
        return profChatButton
    }()
    
    let profileImageView: MaterialImageView = {
        let imageView = MaterialImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
            imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
     
    let currentUserNameLabel: UILabel = {
        let nameLabel = UILabel()
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.alpha = 1.0
            nameLabel.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  18.0)
            nameLabel.backgroundColor = UIColor.clear
            nameLabel.textColor = UIColor.white
            nameLabel.sizeToFit()
            nameLabel.textAlignment = NSTextAlignment.center
        return nameLabel
    }()
    
    let distanceLabel: UILabel = {
        let distLabel = UILabel()
            distLabel.translatesAutoresizingMaskIntoConstraints = false
            distLabel.alpha = 1.0
            distLabel.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  14.0)
            distLabel.backgroundColor = UIColor.clear
            distLabel.textColor = UIColor.white
            distLabel.sizeToFit()
            distLabel.textAlignment = NSTextAlignment.center
        return distLabel
    }()
    
    let addPhotosToGalleryLabel: UILabel = {
        let galleryLabel = UILabel()
            galleryLabel.translatesAutoresizingMaskIntoConstraints = false
            galleryLabel.isHidden = false
            galleryLabel.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  18.0)
            galleryLabel.backgroundColor = UIColor.clear
            galleryLabel.textColor = UIColor.white
            galleryLabel.sizeToFit()
            galleryLabel.textAlignment = NSTextAlignment.center
            galleryLabel.text = "Add Photos to Your Gallery"
        return galleryLabel
    }()
    
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = nil
        setupMainView()
        selectedUser?.didIBlockThisUser(selectedUser: selectedUser!)
        collectionView!.register(GalleryCollectionCell.self, forCellWithReuseIdentifier: "Cell")
        if let userIsBlocked = selectedUser?.isBlocked{
            print("inside userIsBlocked: \(userIsBlocked)")
            if userIsBlocked == true {
                profileChatButton.isHidden = true
            }else{
                didUserBlockMe(selectedUser: selectedUser!)
            }
        }
        print("The user blocked me: \(CurrentUser._amIBlocked)")
        checkUserAndSetupUI()
        setupBackgroundImageView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func checkUserAndSetupUI(){
        if selectedUser == nil || selectedUser?.postKey == CurrentUser._postKey{
            self.profileChatButton.isHidden = true
            let btnImage = UIImage(named: "add_photo_btn")
            self.profileImageView.loadImageUsingCacheWithUrlString(urlString: CurrentUser._profileImageUrl)
            self.currentUserNameLabel.text = CurrentUser._userName
            self.navigationItem.title = CurrentUser._userName
            self.addPhotoButton.setImage(btnImage, for: .normal)
            self.addPhotoButton.addTarget(self, action: #selector(handleAddPhotoButtonTapped), for: .touchUpInside)
            self.blockButton.isHidden = true
            observeGallery(uid: CurrentUser._postKey)
        }else if (selectedUser?.isBlocked)! == false{
            //self.profileChatButton.isHidden = false
            let btnImage = UIImage(named: "blocker")
            blockButton.isHidden = false
            blockButton.setTitle("Block", for: .normal)
            blockButton.setImage(btnImage, for: .normal)
            blockButton.addTarget(self, action: #selector(handleBlockUserTapped), for: .touchUpInside)
            setupSelectedUserProfile()
            observeGallery(uid: (selectedUser?.postKey)!)
            addPhotosToGalleryLabel.text = "No Photos in Gallery"
        }else{
            //self.profileChatButton.isHidden = true
            let btnImage = UIImage(named: "unblocker")
            blockButton.isHidden = false
            blockButton.setTitle("Unblock", for: .normal)
            blockButton.setImage(btnImage, for: .normal)
            blockButton.addTarget(self, action: #selector(handleUnblockUserTapped), for: .touchUpInside)
            setupSelectedUserProfile()
            observeGallery(uid: (selectedUser?.postKey)!)
            addPhotosToGalleryLabel.text = "No Photos in Gallery"
        }
    }
    
    func didUserBlockMe(selectedUser: User){
        print("Inside didUserBlockMe")
        let getUserInfoWithSelectedUserID = DataService.ds.REF_USERS.child(selectedUser.postKey)
        let usersListOfBlockedUsers = getUserInfoWithSelectedUserID.child("blocked_users")
        let amIInTheList = usersListOfBlockedUsers.child(CurrentUser._postKey)
        
        amIInTheList.observe(.value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{ //Not Blocked
                self.profileChatButton.isHidden = false
            }else{
                self.profileChatButton.isHidden = true
            }
        }, withCancel: nil)
    }

    //MARK: - Handlers
    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func handleDelete(){
        let indexPaths = collectionView!.indexPathsForSelectedItems! as [NSIndexPath]
        for indexPath in indexPaths{
            let indexPosition = indexPath.item
                let galleryItem = galleryArray[indexPosition]
                    if let cellID = galleryItem.postKey{
                        DataService.ds.REF_USERS_GALLERY.child(CurrentUser._postKey).child(cellID).removeValue()
                        DataService.ds.REF_GALLERYIMAGES.child(cellID).removeValue()
                        galleryArray.remove(at: indexPosition)
                        attemptReloadOfTable()
                    }
            }
        collectionView!.deleteItems(at: indexPaths as [IndexPath])
    }
    
    func handleAddPhotoButtonTapped(){
            let alertController = UIAlertController(title: "Edit/Add Photo", message: "Do you want to add to gallery or edit your profile picture", preferredStyle: .alert)
            let buttonOne = UIAlertAction(title: "Edit Profile Picture", style: .default) { (action) in
                self.photoChoice = "Profile"
                //self.handleImageSelector()
                self.pickPhoto()
            }
            let buttonTwo = UIAlertAction(title: "Add to Profile Gallery", style: .default) { (action) in
                self.photoChoice = "Gallery"
                self.handleImageSelector()
                //self.pickPhoto()
            }
            let buttonCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("Inside Cancel")
            }
            
            alertController.addAction(buttonOne)
            alertController.addAction(buttonTwo)
            alertController.addAction(buttonCancel)
            
            present(alertController, animated: true, completion: nil)
    }
    
     func handleImageSelector(){
         let sheet = UIAlertController(title: "Media Messages", message: "Please select a media", preferredStyle: .actionSheet)
         let cancel = UIAlertAction(title: "Cancel", style: .cancel)
             { (alert:UIAlertAction) in
                sheet.dismiss(animated: true, completion: nil)
             }
             
             let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert: UIAlertAction) in
                self.takePhotoWithCamera()
             }
             
             let photoLibary = UIAlertAction(title: "Photo Library", style: .default)
             { (alert: UIAlertAction) in
                self.getMediaFrom(type: kUTTypeImage)
             }
             
             let videoLibrary = UIAlertAction(title: "Video Library", style: .default)
             { (alert: UIAlertAction) in
                self.getMediaFrom(type: kUTTypeMovie)
             }
         
             sheet.addAction(takePhoto)
             sheet.addAction(photoLibary)
             sheet.addAction(videoLibrary)
             sheet.addAction(cancel)
         self.present(sheet, animated: true, completion: nil)
    }
    
    private func getMediaFrom(type: CFString){
        let mediaPicker = UIImagePickerController()
            mediaPicker.delegate = self
            mediaPicker.mediaTypes = [type as String]
        
        present(mediaPicker, animated: true, completion: nil)
    }
    
    func handleBlockUserTapped(){
        let alert = UIAlertController(title: "Block User", message: "Are you sure that you want to BLOCK this user?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction) in
            let currentUserRef = DataService.ds.REF_USER_CURRENT
            let blockedUserID = self.selectedUser!.postKey
            currentUserRef.child("blocked_users").updateChildValues([blockedUserID: 1])
            CurrentUser._blockedUsersArray?.append(blockedUserID)
            self.selectedUser?.isBlocked = true
            self.blockButton.setImage(UIImage(named: "unblocker"), for: .normal)
            self.blockButton.setTitle("Unblock", for: .normal)
            self.blockButton.removeTarget(self, action: #selector(self.handleBlockUserTapped), for: .touchUpInside)
            self.blockButton.addTarget(self, action: #selector(self.handleUnblockUserTapped), for: .touchUpInside)
            self.profileChatButton.isHidden = true
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func handleUnblockUserTapped(){
        let alert = UIAlertController(title: "Unblock User", message: "Are you sure that you want to UNBLOCK this user?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction) in
            let currentUserRef = DataService.ds.REF_USER_CURRENT
            let blockedUserID = self.selectedUser!.postKey
            currentUserRef.child("blocked_users").child(blockedUserID).removeValue()
            CurrentUser._blockedUsersArray = CurrentUser._blockedUsersArray?.filter({$0 != blockedUserID})
            self.selectedUser?.isBlocked = false
            self.blockButton.setImage(UIImage(named: "blocker"), for: .normal)
            self.blockButton.setTitle("Block", for: .normal)
            self.blockButton.removeTarget(self, action: #selector(self.handleUnblockUserTapped), for: .touchUpInside)
            self.blockButton.addTarget(self, action: #selector(self.handleBlockUserTapped), for: .touchUpInside)
            self.profileChatButton.isHidden = false
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func attemptReloadOfTable(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadGallery), userInfo: nil, repeats: false)
    }
    
    func handleReloadGallery(){
        DispatchQueue.main.async{
            self.collectionView.reloadData()
        }
    }
    
    func handleShowChatControllerForSelectedUser(){
        let chatLogController = ChatViewController()
            chatLogController.senderId = CurrentUser._postKey
            chatLogController.senderDisplayName = CurrentUser._userName
            chatLogController.user = selectedUser
        
        var img: UIImage?
        if let url = selectedUser?.profileImageUrl{
            img = imageCache.object(forKey: url as NSString) as UIImage?
        }
        
        chatLogController.messageImage = img
        
        let navController = UINavigationController(rootViewController: chatLogController)
        present(navController, animated: true, completion: nil)
        
    }

    
    //MARK: - Observe Method
    func observeGallery(uid: String){
        //guard let uid = FIRAuth.auth()?.currentUser!.uid else { return }
        let userGalleryPostRef = DataService.ds.REF_USERS_GALLERY.child(uid)
        
        userGalleryPostRef.observe(.childAdded, with: { (snapshot) in
            let galleryId = snapshot.key
            let galleryPostRef = DataService.ds.REF_GALLERYIMAGES.child(galleryId)
            
            galleryPostRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        let galleryPost = GalleryImage(key: snapshot.key)
                        galleryPost.setValuesForKeys(dictionary)
                        self.galleryArray.append(galleryPost)
                        
                        self.attemptReloadOfTable()
                    }
                }, withCancel: nil)
            }, withCancel: nil)
    }
    
    //MARK: - Zoom In and Out
    func performZoomInForStartingImageView(startingView: UIView, photoImage: UIImageView){
        self.startingView = startingView
        
        startingFrame = startingView.superview?.convert(startingView.frame, to: nil)
        
        let zoomingView = UIImageView(frame: startingFrame!)
            zoomingView.backgroundColor = UIColor.red
            zoomingView.isUserInteractionEnabled = true
            zoomingView.contentMode = .scaleAspectFill
            zoomingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            zoomingView.image = photoImage.image
        if let keyWindow = UIApplication.shared.keyWindow{
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView!.alpha = 1
                self.startingView?.isHidden = true
                
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingView.center = keyWindow.center
                }, completion: nil)
        }
    }
    
    func handleZoomOut(tapGesture: UITapGestureRecognizer){
        if let zoomOutImageView = tapGesture.view{
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                
                
                }, completion: { (completed) in
                    zoomOutImageView.removeFromSuperview()
                    self.startingView?.isHidden = false
                    self.blackBackgroundView?.removeFromSuperview()
            })
        }
    }
}//end class

//MARK: - Extension UICollectionView

extension ProfileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        addPhotosToGalleryLabel.isHidden = galleryArray.count > 0
        
        let galleryImage = galleryArray[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! GalleryCollectionCell
            cell.gallery = galleryImage
            cell.editing = isEditing
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing{
            let galleryImage = galleryArray[indexPath.row]
            if galleryImage.mediaType == "PHOTO"{
                if let cell = collectionView.cellForItem(at: indexPath as IndexPath),
                    let cellImageView = cell.contentView.subviews[0] as? UIImageView{
                    performZoomInForStartingImageView(startingView: cell.contentView, photoImage: cellImageView)
                    navigationItem.rightBarButtonItem = nil
                }
            }else{
                if let galleryVidUrl = URL(string: galleryImage.galleryVideoUrl!){
                    player = AVPlayer(url: galleryVidUrl)
                    let playerController = AVPlayerViewController()
                    playerController.player = player
                    present(playerController, animated: true){
                        playerController.player!.play()
                    }
                }
                
                
                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)

            }
            
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEditing{
            if collectionView.indexPathsForSelectedItems!.count == 0{
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    
    func playerDidFinishPlaying(note: NSNotification){
        DispatchQueue.main.async {
            self.player!.pause()
            
        }
        
    }
}//end extension


