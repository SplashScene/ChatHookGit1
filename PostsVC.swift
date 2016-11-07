//
//  PostsVC.swift
//  driveby_Showcase
//
//  Created by Kevin Farm on 4/13/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import MobileCoreServices
import AVFoundation
import AVKit
import Social
import CoreLocation

class PostsVC: UIViewController{
    var profileView: ProfileViewController?
    var roomsController: RoomsViewController?
    var commentViewController: CommentViewController?
    var geocoder: CLGeocoder?
    var postCityAndState: String?
    var cellID = "cellID"
    var postedImage: UIImage?
    var postedVideo: NSURL?
    var postedText: String?
    var messageImage: UIImage?
    var parentRoom: PublicRoom?
    var timer: Timer?
    var navBar: UINavigationBar = UINavigationBar()
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingView: UIView?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playButton: UIButton?
    var activityIndicator: UIActivityIndicatorView?
    
    var postsArray = [UserPost]()
    var preventAnimation = Set<NSIndexPath>()
    
    let topView: MaterialView = {
        let view = MaterialView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor.white
        return view
    }()
    
    let postTextField: MaterialTextField = {
        let ptf = MaterialTextField()
            ptf.placeholder = "What's on your mind?"
            ptf.translatesAutoresizingMaskIntoConstraints = false
        return ptf
    }()
    
    lazy var imageSelectorView: UIImageView = {
        let isv = UIImageView()
            isv.translatesAutoresizingMaskIntoConstraints = false
            isv.image = UIImage(named: "camera_icon_snap")
            isv.contentMode = .scaleAspectFit
            isv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageSelector)))
            isv.isUserInteractionEnabled = true
        return isv
    }()
    
    lazy var postButton: MaterialButton = {
        let pb = MaterialButton()
            pb.translatesAutoresizingMaskIntoConstraints = false
            pb.setTitle("Post", for: .normal)
            pb.isUserInteractionEnabled = false
            pb.alpha = 0.5
            pb.addTarget(self, action: #selector(handlePostButtonTapped), for: .touchUpInside)
        return pb
    }()

    let postTableView: UITableView = {
        let ptv = UITableView()
            ptv.translatesAutoresizingMaskIntoConstraints = false
            ptv.backgroundColor = UIColor(r: 220, g: 220, b: 220)
            //ptv.allowsSelection = false
        return ptv
    }()
    
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.addSubview(topView)
        view.addSubview(postTableView)
        
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.register(testPostCell.self, forCellReuseIdentifier: "cellID")
        postTableView.estimatedRowHeight = 400
        postTextField.delegate = self
        
        setupTopView()
        setupPostTableView()
        setupNavBarWithUserOrProgress(progress: nil)
        observePosts()
        handleCityAndState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Handler Methods
    func handleBack(){
        dismiss(animated: true, completion: nil)
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
    
    func handlePostButtonTapped(){
        
        postedText = postTextField.text
        
        if let unwrappedImage = postedImage{
            DataService.ds.putInFirebaseStorage(whichFolder: POST_IMAGES, withOptImage: unwrappedImage, withOptVideoNSURL: nil, withOptUser: nil, withOptText: postedText, withOptRoom: parentRoom!, withOptCityAndState: postCityAndState!, withOptDict: nil)
        }else if let unwrappedVideo = postedVideo{
            DataService.ds.putInFirebaseStorage(whichFolder: POST_IMAGES, withOptImage: nil, withOptVideoNSURL: unwrappedVideo, withOptUser: nil, withOptText: postedText, withOptRoom: parentRoom!, withOptCityAndState: postCityAndState!, withOptDict: nil)
        }else{
            DataService.ds.createFirebasePostEntry(thumbnailUrl: nil, fileUrl: nil, room: parentRoom!, cityAndState: postCityAndState!, postText: postedText!)
            
        }
        
        self.postTextField.text = ""
        self.postTextField.endEditing(true)
        self.imageSelectorView.image = UIImage(named: "camera_icon_snap")
        self.postedImage = nil
        self.postedVideo = nil
        self.postedText = nil
        self.postButton.isUserInteractionEnabled = false
        self.postButton.alpha = 0.5
        adjustPostsNumberOfParentRoom()

    }
    
    private func attemptReloadOfTable(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadPosts), userInfo: nil, repeats: false)
    }

    func handleReloadPosts(){
        DispatchQueue.main.async{
            self.postTableView.reloadData()
        }
    }
    
    func handleDeletePost(sender: UIButton){
        let alert = UIAlertController(title: "Delete Post", message: "Are you sure that you want to DELETE this post?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction) in
            let sharePosition = sender.convert(CGPoint(x: 0, y: 0), to: self.postTableView)
            let indexPath = self.postTableView.indexPathForRow(at: sharePosition)
            if let indPath = indexPath{
                let post = self.postsArray[indPath.row]
                    DataService.ds.deletePostFromFirebase(postToDelete: post)
                
                self.postsArray.remove(at: indPath.row)
                self.postTableView.deleteRows(at: [indPath], with: .automatic)
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func handleShare(sender: UIButton){
        let alertController = UIAlertController(title: "Share", message: "Where do you want to share this post?", preferredStyle: .alert)
        
        let buttonOne = UIAlertAction(title: "Share on Facebook", style: .default) { (action) in
            self.handleSocialShare(sender: sender, trigger: 1)
        }
        
        let buttonTwo = UIAlertAction(title: "Share on Twitter", style: .default) { (action) in
            self.handleSocialShare(sender: sender, trigger: 2)
        }
        
        let buttonCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Inside Cancel")
        }
        
        alertController.addAction(buttonOne)
        alertController.addAction(buttonTwo)
        alertController.addAction(buttonCancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func handleSocialShare(sender: UIButton, trigger: Int){
        let sharePosition = sender.convert(CGPoint(x: 0, y: 0), to: self.postTableView)
        let indexPath = self.postTableView.indexPathForRow(at: sharePosition)
        let cell = self.postTableView.cellForRow(at: indexPath!) as? testPostCell
        
        let vc = trigger == 1 ? SLComposeViewController(forServiceType: SLServiceTypeFacebook) : SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
            if let postText = cell?.descriptionText.text{
                vc?.setInitialText("Check out this great post from ChatHook: \n \(postText)")
            }else{
                vc?.setInitialText("Check out this great post from ChatHook:")
            }
            
            if let image = cell?.showcaseImageView.image{
                vc?.add(image)
            }
      
        present(vc!, animated: true, completion: nil)
    }
    
    func handleProfile(profileView: UIView){
        let profileViewPosition = profileView.convert(CGPoint(x: 0, y: 0), to: self.postTableView)
        if let indexPath = self.postTableView.indexPathForRow(at: profileViewPosition){
            let userPost = postsArray[indexPath.row]
            let getUserInformationFromDatabase = DataService.ds.REF_USERS.child(userPost.fromId!)
                
                getUserInformationFromDatabase.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dictionary = snapshot.value as? [String : AnyObject] else { return }
                    let user = User(postKey: snapshot.key, dictionary: dictionary)
                    self.showProfileControllerForUser(user: user)
                }, withCancel: nil)
        }
    }
    
    func handleCityAndState(){
        if geocoder == nil { geocoder = CLGeocoder() }
        
        geocoder?.reverseGeocodeLocation(CurrentUser._location!){ placemarks, error in
            print("Inside GeoCoding")
            if error != nil{
                print("Error get geoLocation: \(error?.localizedDescription)")
            }else{
                print("Inside geo else")
                let placemark = placemarks?.first
                let city = placemark?.locality!
                let state = placemark?.administrativeArea!
                print("The city is \(city) and the state is \(state)")
                if let postCity = city, let postState = state{
                    self.postCityAndState = "\(postCity), \(postState)"
                }
            }
        }
    }
    
    func handleCommentTapped(sender: UIButton){
        let commentViewPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.postTableView)
        if let indexPath = self.postTableView.indexPathForRow(at: commentViewPosition){
            let userPost = postsArray[indexPath.row]
            let commentViewController = CommentViewController()
                commentViewController.postForComment = userPost
            let navController = UINavigationController(rootViewController: commentViewController)
            present(navController, animated: true, completion: nil)
        }
    }

    //MARK: - Observe Methods
    func observePosts(){
        guard let parentRoomID = parentRoom?.postKey else { return }
        let getParentRoomFromDatabase = DataService.ds.REF_POSTSPERROOM.child(parentRoomID)
        
        getParentRoomFromDatabase.observe(.childAdded, with: { (snapshot) in
            let postID = snapshot.key
            let getFullPostFromDatabase = DataService.ds.REF_POSTS.child(postID)
            
            getFullPostFromDatabase.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                
                let post = UserPost(key: snapshot.key)
                    post.setValuesForKeys(dictionary)
                
                self.postsArray.insert(post, at: 0)
                
                self.attemptReloadOfTable()
                },
                withCancel: nil)
            }, withCancel: nil)
        
        getParentRoomFromDatabase.observe(.childRemoved, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let post = UserPost(key: snapshot.key)
                post.setValuesForKeys(dictionary)
            
            let getAllPostersBlockedUsers = DataService.ds.REF_USERS.child(post.fromId!).child("blocked_users")
            
                getAllPostersBlockedUsers.child(CurrentUser._postKey).observe(.value, with: { (snapshot) in
                        if let _ = snapshot.value as? NSNull {// Can't find value so not blocked
                            self.postsArray.insert(post, at: 0)
                            self.attemptReloadOfTable()
                        }
                    }, withCancel: nil)

            self.attemptReloadOfTable()
            
            }, withCancel: nil)
    }
    
    func adjustLikesInArrayDisplay(sender:UIButton){
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.postTableView)
        let indexPath = self.postTableView.indexPathForRow(at: buttonPosition)
        let cell = self.postTableView.cellForRow(at: indexPath!) as? testPostCell
        let post = postsArray[indexPath!.row]
        var intLikes = Int(post.likes)
        if sender.tag == 1{
            let image = UIImage(named: "like")
            sender.setImage(image, for: .normal)
            intLikes += 1
            let adjustedLikes = NSNumber(value: Int32(intLikes))
            post.likes = adjustedLikes
            cell?.likesLabel.text = getLikesComments(numberOfLikes: post.likes as Int, numberOfComments: post.comments as Int)
        }else{
            let image = UIImage(named: "meh")
            sender.setImage(image, for: .normal)
            intLikes -= 1
            let adjustedLikes = NSNumber(value: Int32(intLikes))
            post.likes = adjustedLikes
            cell?.likesLabel.text = getLikesComments(numberOfLikes: post.likes as Int, numberOfComments: post.comments as Int)
        }
    }
    
    func getLikesComments(numberOfLikes: Int, numberOfComments: Int) -> String {
        var likesCommentsText = ""
        if numberOfLikes == 1 && numberOfComments == 1{
            likesCommentsText = "\(numberOfLikes) Like • \(numberOfComments) Comment"
        } else if numberOfLikes > 1 && numberOfComments == 1{
            likesCommentsText = "\(numberOfLikes) Likes • \(numberOfComments) Comment"
        } else if numberOfLikes == 1 && numberOfComments > 1{
            likesCommentsText = "\(numberOfLikes) Like • \(numberOfComments) Comments"
        } else {
            likesCommentsText = "\(numberOfLikes) Likes • \(numberOfComments) Comments"
        }
        
        return likesCommentsText
    }
    
    func showProfileControllerForUser(user: User){
        let profileController = ProfileViewController()
            profileController.selectedUser = user
        
        let navController = UINavigationController(rootViewController: profileController)
        present(navController, animated: true, completion: nil)
    }
    
   //MARK: - Zoom In and Out Methods
    
    func performZoomInForStartingImageView(startingImageView: UIImageView){
        
            startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
            
            let zoomingView = UIImageView(frame: startingFrame!)
                zoomingView.backgroundColor = UIColor.red
                zoomingView.image = startingImageView.image
                zoomingView.isUserInteractionEnabled = true
                zoomingView.contentMode = .scaleAspectFill
                zoomingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            
            if let keyWindow = UIApplication.shared.keyWindow{
                keyWindow.addSubview(zoomingView)
                
                blackBackgroundView = UIView(frame: keyWindow.frame)
                blackBackgroundView?.backgroundColor = UIColor.black
                blackBackgroundView?.alpha = 0
                keyWindow.addSubview(blackBackgroundView!)
                
                keyWindow.addSubview(zoomingView)
                
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut,
                               animations: {
                                self.blackBackgroundView!.alpha = 1
                                self.startingView?.isHidden = true
                                
                                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                                
                                zoomingView.frame = CGRect(x: 0,
                                                           y: 0,
                                                           width: keyWindow.frame.width,
                                                           height: height)
                                zoomingView.center = keyWindow.center
                    },
                               completion: nil)
            }

    }

    func handleZoomOut(tapGesture: UITapGestureRecognizer){
        if let zoomOutImageView = tapGesture.view{
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                                zoomOutImageView.frame = self.startingFrame!
                                self.blackBackgroundView?.alpha = 0
                            },
                           completion: { (completed) in
                                zoomOutImageView.removeFromSuperview()
                                self.blackBackgroundView?.removeFromSuperview()
                                self.startingView?.isHidden = false
                            })
        }
    }
    
    func adjustPostsNumberOfParentRoom(){
        let intComments = Int((parentRoom?.posts)!) + 1
        let adjustedComments = NSNumber(value: Int32(intComments))
        parentRoom!.posts = adjustedComments
        parentRoom!.roomRef.child("posts").setValue(adjustedComments)
    }

    //MARK: - Video Player Methods
    
    func playerDidFinishPlaying(note: NSNotification){
        DispatchQueue.main.async {
            self.player!.pause()
        }
    }

}//end class

extension PostsVC:UITableViewDelegate, UITableViewDataSource{
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let customCell:testPostCell = cell as! testPostCell
            customCell.backgroundColor = UIColor.clear

        if !preventAnimation.contains(indexPath as NSIndexPath){
            preventAnimation.insert(indexPath as NSIndexPath)
            TipInCellAnimator.animate(cell: customCell)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let customCell:testPostCell = cell as! testPostCell
        customCell.backgroundColor = UIColor.white
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        playButton?.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath as IndexPath) as! testPostCell
        let post = postsArray[indexPath.row]
            cell.userPost = post
            cell.postViewController = self
        
        let descripFrame = cell.descriptionText.superview?.convert(cell.descriptionText.frame, to: nil)
        print("The descripFrame is: \(descripFrame?.height)")
    
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let statusText = postsArray[indexPath.row].postText{
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            
            if let _ = postsArray[indexPath.row].showcaseUrl{
                let knownHeight: CGFloat = 50 + 205 + 16 + 35 + 9 + 30
                print("The rect height is: \(rect.height)")
                switch(rect.height){
                    case 50...99: return rect.height + knownHeight + 40
                    case 100...149: return rect.height + knownHeight + 70
                    case 150...199: return rect.height + knownHeight + 90
                    case 200...299:  return rect.height + knownHeight + 175
                    case 300...399:  return rect.height + knownHeight + rect.height / 3
                    default: return rect.height + knownHeight + 15
                }
            }else{
                let knownHeight: CGFloat = 50 + 16 + 35 + 9 + 30
                print("The rect height with no picture is: \(rect.height)")
                    switch(rect.height){
                        case 50...99: return rect.height + knownHeight + 40
                        case 100...149: return rect.height + knownHeight + 60
                        case 150...199: return rect.height + knownHeight + 80
                        case 200...300:  return rect.height + knownHeight + 100
                        case 300...399:  return rect.height + knownHeight + 140
                        default: return rect.height + knownHeight + 15
                    }
            }
        }
        let noTextHeight:CGFloat = 50 + 205 + 16 + 35 + 9 + 50
        return noTextHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = postTableView.cellForRow(at: indexPath) as? testPostCell
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        let getPostAtIndexPath = postsArray[indexPath.row]
        
        if getPostAtIndexPath.mediaType == "VIDEO"{

            let movieURL = URL(string: getPostAtIndexPath.showcaseUrl!)
            player = AVPlayer(url: movieURL!)
            playerLayer = AVPlayerLayer(player: player)
            
            let playerController = AVPlayerViewController()
                playerController.player = player
            
            present(playerController, animated: true){
                playerController.player!.play()
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        }
        
        if getPostAtIndexPath.mediaType == "PHOTO"{
            performZoomInForStartingImageView(startingImageView: (cell?.showcaseImageView)!)
        }
    }
}//end extension

extension PostsVC: UITextFieldDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == postTextField
        {
            let oldStr = postTextField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0
            {
                postButton.isUserInteractionEnabled = false
            }else
            {
                postButton.isUserInteractionEnabled = true
                postButton.alpha = 1.0
            }
        }
        return true
    }
}








