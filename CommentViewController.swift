//
//  CommentViewController.swift
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
import Social
import CoreLocation

class CommentViewController: UIViewController{
    var profileView: ProfileViewController?
    var postsController: PostsVC?
    var postForComment: UserPost?
    var geocoder: CLGeocoder?
    var postCityAndState: String?
    var cellID = "cellID"
    var postID = "postID"
    var postedText: String?
    var timer: Timer?
    var navBar: UINavigationBar = UINavigationBar()
    var commentsArray = [Comment]()
    var postViewBottomAnchor: NSLayoutConstraint?
    
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
    
    lazy var commmentButton: MaterialButton = {
        let pb = MaterialButton()
            pb.translatesAutoresizingMaskIntoConstraints = false
            pb.setTitle("Comment", for: .normal)
            pb.addTarget(self, action: #selector(CommentViewController.handleCommentButtonTapped), for: .touchUpInside)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.addSubview(topView)
        view.addSubview(postTableView)
        title = "Post Comments"
        
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.register(CommentViewCell.self, forCellReuseIdentifier: "cellID")
        postTableView.register(testPostCell.self, forCellReuseIdentifier: "postID")
        setupTopView()
        setupPostTableView()
        
        
        observeComments()
        handleCityAndState()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleReloadPosts()
    }
    
    //MARK: - Setup Methods

    func setupTopView(){
        //need x, y, width and height constraints
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 72).isActive = true
        topView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        topView.addSubview(postTextField)
        topView.addSubview(commmentButton)
        
        postTextField.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 8).isActive = true
        postTextField.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        postTextField.widthAnchor.constraint(equalToConstant: 255).isActive = true
        postTextField.heightAnchor.constraint(equalTo: topView.heightAnchor, constant: -16).isActive = true
        
        commmentButton.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -8).isActive = true
        commmentButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        commmentButton.widthAnchor.constraint(equalToConstant: 85).isActive = true
        commmentButton.heightAnchor.constraint(equalTo: topView.heightAnchor, constant: -16).isActive = true
    }
    
    func setupPostTableView(){
        postTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postTableView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8).isActive = true
        postTableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        postTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
    }
    
    //MARK: - Handler Methods
    func handleCommentButtonTapped(){
        guard let toPost = postForComment?.postKey,
              let postedComment = self.postTextField.text, postedComment != "" else { return }
        let commentRef = DataService.ds.REF_USERS_COMMENTS.childByAutoId()
        let timestamp: Int = Int(NSDate().timeIntervalSince1970)
        
            let commentItem:[String:AnyObject] =
                    ["fromId": CurrentUser._postKey as AnyObject,
                     "commentText": postedComment as AnyObject,
                     "timestamp": timestamp as AnyObject,
                     "toPost": toPost as AnyObject,
                     "likes": 0 as AnyObject,
                     "authorPic": CurrentUser._profileImageUrl as AnyObject,
                     "authorName": CurrentUser._userName as AnyObject,
                     "cityAndState": postCityAndState! as AnyObject]
            
            commentRef.updateChildValues(commentItem) { (error, ref) in
                if error != nil { print(error?.localizedDescription as Any); return }
                
                let postCommentRef = DataService.ds.REF_BASE.child("post_comments").child(toPost)
                let commentID = commentRef.key
                postCommentRef.updateChildValues([commentID: 1])
            }
        
        self.postTextField.text = ""
        self.postTextField.endEditing(true)
        adjustComments()
        handleReloadPosts()
    }
    
    func handleBack(){
        dismiss(animated: true, completion: nil)
    }

    func handleReloadPosts(){
        DispatchQueue.main.async{
            self.postTableView.reloadData()
        }
    }
    
    func handleFacebookShare(shareView: UIView){
        let sharePosition = shareView.convert(CGPoint(x: 0, y: 0), to: self.postTableView)
        let indexPath = self.postTableView.indexPathForRow(at: sharePosition)
        let cell = self.postTableView.cellForRow(at: indexPath!) as? testPostCell
        
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        
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
    
    func handleTwitterShare(shareView: UIView){
        let sharePosition = shareView.convert(CGPoint(x: 0, y: 0), to: self.postTableView)
        let indexPath = self.postTableView.indexPathForRow(at: sharePosition)
        let cell = self.postTableView.cellForRow(at: indexPath!) as? testPostCell
        
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
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
    
    func adjustComments(){
        let intComments = Int((postForComment?.comments)!) + 1
        let adjustedComments = NSNumber(value: Int32(intComments))
        postForComment!.comments = adjustedComments
        postForComment!.postRef.child("comments").setValue(adjustedComments)
    }
    
    func handleCityAndState(){
        if geocoder == nil { geocoder = CLGeocoder() }
        
        geocoder?.reverseGeocodeLocation(CurrentUser._location!){ placemarks, error in
            if error != nil{
                print("Error get geoLocation: \(error?.localizedDescription)")
            }else{
                let placemark = placemarks?.first
                let city = placemark?.locality!
                let state = placemark?.administrativeArea!
                    if let postCity = city, let postState = state{
                        self.postCityAndState = "\(postCity), \(postState)"
                    }
            }
        }
    }
    
    //MARK: - Observe Methods
    
    func observeComments(){
        guard let postID = postForComment?.postKey else { return }
        let commentPostsRef = DataService.ds.REF_POST_COMMENTS.child(postID)
        
        commentPostsRef.observe(.value, with: {snapshot in
            self.commentsArray = []
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                    for snap in snapshots{
                        let commentKey = snap.key
                        let userCommentRef = DataService.ds.REF_USERS_COMMENTS.child(commentKey)
                        userCommentRef.observeSingleEvent(of: .value, with: { (snapshot) in
                                if let commentDict = snapshot.value as? [String: AnyObject]{
                                    let comment = Comment(key: snapshot.key)
                                        comment.setValuesForKeys(commentDict)
                                    self.commentsArray.append(comment)
                                    
                                    self.timer?.invalidate()
                                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadPosts), userInfo: nil, repeats: false)
                                }
                            }, withCancel: nil)
                    }
                }       
        })
    }
    
    func showProfileControllerForUser(user: User){
        let profileController = ProfileViewController()
        profileController.selectedUser = user
        
        let navController = UINavigationController(rootViewController: profileController)
        present(navController, animated: true, completion: nil)
    }
    
}//end class

extension CommentViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let customCell: testPostCell = cell as! testPostCell
                customCell.backgroundColor = UIColor(r: 240, g: 248, b: 255)
        }else{
            let customCell:CommentViewCell = cell as! CommentViewCell
                customCell.backgroundColor = UIColor.clear
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == 0{
            if let userPost = postForComment{
                let cell = tableView.dequeueReusableCell(withIdentifier: postID, for: indexPath as IndexPath) as! testPostCell
                    cell.userPost = userPost
                return cell
            }else{
                let cell = testPostCell()
                return cell
            }
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath as IndexPath) as! CommentViewCell
            let indexPathAdjustment = indexPath.row - 1
            let comment = commentsArray[indexPathAdjustment]
                cell.userComment = comment
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { return }
        let cell = postTableView.cellForRow(at: indexPath) as? CommentViewCell
            cell?.selectionStyle = UITableViewCellSelectionStyle.none

        let indexPathAdjustment = indexPath.row - 1
        let comment = commentsArray[indexPathAdjustment]
        let ref = DataService.ds.REF_USERS.child(comment.fromId!)
        
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dictionary = snapshot.value as? [String : AnyObject] else { return }
                    let user = User(postKey: snapshot.key, dictionary: dictionary)
                    self.showProfileControllerForUser(user: user)
                }, withCancel: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentsArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if let statusText = postForComment?.postText{
                let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
                
                if let _ = postForComment?.showcaseUrl{
                    let knownHeight: CGFloat = 50 + 205 + 16 + 35 + 9 + 30
                    print("The rect height is: \(rect.height)")
                        switch(rect.height){
                            case 50...99: return rect.height + knownHeight + 40
                            case 100...149: return rect.height + knownHeight + 70
                            case 150...199: return rect.height + knownHeight + 90
                            case 200...299:  return rect.height + knownHeight + 175
                            case 300...399:  return rect.height + knownHeight + 225
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
           
        } else {
            let indexPathAdjustment = indexPath.row - 1
            var commentRowHeight: CGFloat = 0.0
            
            if let statusText = commentsArray[indexPathAdjustment].commentText{
                let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
                print("My comment rect height is: \(rect.height)")
                    switch(rect.height){
                    case 50...99: commentRowHeight = rect.height + 80
                    case 100...149: commentRowHeight = rect.height + 140
                    case 150...199: commentRowHeight = rect.height + 165
                    case 200...300:  commentRowHeight = rect.height + 285
                    default: commentRowHeight = 92
                    }
                
            }
            
            return commentRowHeight
        }
    }
    
}//end extension


//extension CommentViewController: UITextFieldDelegate{
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == postTextField
//        {
//            let oldStr = postTextField.text! as NSString
//            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
//            if newStr.length == 0
//            {
//                commmentButton.isUserInteractionEnabled = false
//            }else
//            {
//                commmentButton.isUserInteractionEnabled = true
//                commmentButton.alpha = 1.0
//            }
//        }
//        return true
//    }
//}








