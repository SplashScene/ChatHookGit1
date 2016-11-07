//
//  DataService.swift
//  driveby_Showcase
//
//  Created by Kevin Farm on 4/12/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import AVFoundation

let URL_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = URL_BASE
    
    private var _REF_USERS = URL_BASE.child("users")
    private var _REF_USERS_NAMES = URL_BASE.child("user_names")
    private var _REF_USERSONLINE = URL_BASE.child("users_online")
    private var _REF_USERMESSAGES = URL_BASE.child("user_messages")
    private var _REF_USERS_GALLERY = URL_BASE.child("users_gallery")
    private var _REF_USERS_COMMENTS = URL_BASE.child("users_comments")

    private var _REF_POSTS = URL_BASE.child("posts")
    private var _REF_POSTSPERROOM = URL_BASE.child("posts_per_room")
    private var _REF_POST_COMMENTS = URL_BASE.child("post_comments")
    
    private var _REF_MESSAGES = URL_BASE.child("messages")
    private var _REF_CHATROOMS = URL_BASE.child("publicchatrooms")
    private var _REF_GALLERYIMAGES = URL_BASE.child("gallery_images")
    
    let timestamp: Int = Int(NSDate().timeIntervalSince1970)
    
    
    
    var REF_BASE: FIRDatabaseReference{ return _REF_BASE }
    
    var REF_USERS: FIRDatabaseReference{ return _REF_USERS }
    var REF_USERS_GALLERY: FIRDatabaseReference { return _REF_USERS_GALLERY }
    var REF_USERS_COMMENTS: FIRDatabaseReference { return _REF_USERS_COMMENTS}
    var REF_USERS_NAMES: FIRDatabaseReference { return _REF_USERS_NAMES}
    var REF_USERSONLINE: FIRDatabaseReference { return _REF_USERSONLINE }
    var REF_USERMESSAGES: FIRDatabaseReference { return _REF_USERMESSAGES }
    
    var REF_POSTS: FIRDatabaseReference{ return _REF_POSTS }
    var REF_POSTSPERROOM: FIRDatabaseReference { return _REF_POSTSPERROOM }
    var REF_POST_COMMENTS: FIRDatabaseReference { return _REF_POST_COMMENTS}
    
    var REF_MESSAGES: FIRDatabaseReference{ return _REF_MESSAGES }
    var REF_CHATROOMS: FIRDatabaseReference{ return _REF_CHATROOMS }
    var REF_GALLERYIMAGES: FIRDatabaseReference { return _REF_GALLERYIMAGES }
    
    var REF_USER_CURRENT: FIRDatabaseReference{
        let uid = UserDefaults.standard.value(forKey: KEY_UID) as! String
        let user = URL_BASE.child("users").child(uid)
        return user
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, AnyObject>){
        REF_USERS.child(uid).setValue(user)
    }
    
    func putInFirebaseStorage(whichFolder: String, withOptImage image: UIImage?, withOptVideoNSURL video: NSURL?, withOptUser user: User?, withOptText text: String?, withOptRoom room: PublicRoom?, withOptCityAndState cityAndState: String?, withOptDict introDict: [String: String]?){
        let imageName = NSUUID().uuidString
        print("I am in dataService put into Firebase")
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            if let photo = image{
                let photoRef = STORAGE_BASE.child(whichFolder).child(uid).child("photos").child(imageName)
                if let uploadData = UIImageJPEGRepresentation(photo, 0.2){
                    let metadata = FIRStorageMetadata()
                    metadata.contentType = "image/jpg"
                    photoRef.put(uploadData as Data, metadata: metadata, completion: { (metadata, error) in
                        if error != nil{
                            print(error.debugDescription)
                            return
                        }
                        
                        if let imageUrl = metadata?.downloadURL()?.absoluteString{
                            switch whichFolder{
                            case GALLERY_IMAGES: self.createFirebaseGalleryEntry(galleryImageUrl: imageUrl, galleryVideoUrl: nil)
                            case PROFILE_IMAGES: if let userDeets = introDict { self.createFirebaseUserEntry(values: userDeets, profileImageUrl: imageUrl) } else { self.updateProfilePic(profilePic: imageUrl) }
                            case MESSAGE_IMAGES: if let toUser = user{ self.createFirebaseMessageEntry(thumbnailUrl: nil, fileUrl: imageUrl, user: toUser) }
                            case POST_IMAGES: if let toRoom = room, let cityState = cityAndState{
                                if let postText = text{
                                    self.createFirebasePostEntry(thumbnailUrl: nil, fileUrl: imageUrl, room: toRoom, cityAndState:cityState, postText: postText )
                                }else{
                                    self.createFirebasePostEntry(thumbnailUrl: nil, fileUrl: imageUrl, room: toRoom, cityAndState:cityState, postText: nil )
                                }
                                }
                            default: print("Unexpected Option")
                            }//end switch
                        }//end if let imageUrl
                    })//end photoRef.put
                }//end if uploadData
            }else if let movie = video{
                let videoRef = STORAGE_BASE.child(whichFolder).child(uid).child("videos").child(imageName)
                if let uploadData = NSData(contentsOf: movie as URL){
                    let metadata = FIRStorageMetadata()
                        metadata.contentType = "video/mp4"
                    videoRef.put(uploadData as Data, metadata: metadata, completion: { (metadata, error) in
                        if error != nil{
                            print(error.debugDescription)
                            return
                        }
                        
                        if let videoUrl = metadata?.downloadURL()?.absoluteString{
                            if let thumbnailImage = self.thumbnailImageForVideoUrl(videoUrl: movie){
                                let galleryRef = STORAGE_BASE.child(whichFolder).child(uid).child("photos").child(imageName)
                                if let uploadData = UIImageJPEGRepresentation(thumbnailImage, 0.2){
                                    let metadata = FIRStorageMetadata()
                                    metadata.contentType = "image/jpg"
                                    galleryRef.put(uploadData as Data, metadata: metadata, completion: { (metadata, error) in
                                        if error != nil{
                                            print(error.debugDescription)
                                            return
                                        }
                                        if let thumbnailUrl = metadata?.downloadURL()?.absoluteString{
                                            imageCache.setObject(thumbnailImage, forKey: videoUrl as NSString)
                                            switch whichFolder{
                                            case GALLERY_IMAGES: self.createFirebaseGalleryEntry(galleryImageUrl: thumbnailUrl, galleryVideoUrl: videoUrl)
                                            //case PROFILE_IMAGES: self.updateProfilePic(profilePic: imageUrl)
                                            case MESSAGE_IMAGES: if let toUser = user{ self.createFirebaseMessageEntry(thumbnailUrl: thumbnailUrl, fileUrl: videoUrl, user: toUser) }
                                            case POST_IMAGES: if let toRoom = room, let cityState = cityAndState{
                                                if let postText = text{
                                                    self.createFirebasePostEntry(thumbnailUrl: thumbnailUrl, fileUrl: videoUrl, room: toRoom, cityAndState:cityState, postText: postText )
                                                }else{
                                                    self.createFirebasePostEntry(thumbnailUrl: thumbnailUrl, fileUrl: videoUrl, room: toRoom, cityAndState:cityState, postText: nil )
                                                }
                                                }
                                            default: print("Unexpected Option")
                                            }//end switch
                                        }
                                    })//end galleryRef put
                                }//end if uploadData
                            }//end if thumbnailImage
                        }// if videoUrl
                    })//end videoRef put
                }//end if uploadData
            }
        }
    }//end method
 
 
    func createFirebaseGalleryEntry(galleryImageUrl: String, galleryVideoUrl: String?){
        let galleryRef = REF_GALLERYIMAGES.childByAutoId()
        let galleryItem: Dictionary<String, AnyObject>
        
            if let videoUrl = galleryVideoUrl{
                galleryItem = ["fromId": CurrentUser._postKey as AnyObject,
                               "timestamp": timestamp as AnyObject,
                               "mediaType": "VIDEO" as AnyObject,
                               "galleryImageUrl": galleryImageUrl as AnyObject,
                               "galleryVideoUrl": videoUrl as AnyObject]
            }else{
                galleryItem = ["fromId": CurrentUser._postKey as AnyObject,
                               "timestamp": timestamp as AnyObject,
                               "mediaType": "PHOTO" as AnyObject,
                               "galleryImageUrl": galleryImageUrl as AnyObject]
            }
        
            galleryRef.updateChildValues(galleryItem, withCompletionBlock: {(error, ref) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                let galleryUserRef = self.REF_USERS_GALLERY.child(CurrentUser._postKey)
                let galleryID = galleryRef.key
                galleryUserRef.updateChildValues([galleryID: 1])
            
            })
        }
    
    func createFirebaseMessageEntry(thumbnailUrl: String?, fileUrl: String, user: User){
        let toId = user.postKey
        let itemRef = REF_MESSAGES.childByAutoId()
        let messageItem: Dictionary<String, AnyObject>
        
        if let thumbUrl = thumbnailUrl{
            messageItem = [ "fromId": CurrentUser._postKey as AnyObject ,
                            "imageUrl": fileUrl as AnyObject,
                            "timestamp": timestamp as AnyObject,
                            "toId": toId as AnyObject,
                            "mediaType": "VIDEO" as AnyObject,
                            "thumbnailUrl": thumbUrl as AnyObject ]
        }else{
            messageItem = [ "fromId": CurrentUser._postKey as AnyObject ,
                            "imageUrl": fileUrl as AnyObject,
                            "timestamp": timestamp as AnyObject,
                            "toId": toId as AnyObject,
                            "mediaType": "PHOTO" as AnyObject ]
        }
        
        itemRef.updateChildValues(messageItem){ (error, ref) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            let userMessageRef = self._REF_USERMESSAGES.child(CurrentUser._postKey).child(toId)
            let recipientUserMessagesRef = self.REF_USERMESSAGES.child(toId).child(CurrentUser._postKey)
            let messageID = itemRef.key
            userMessageRef.updateChildValues([messageID: 1])
            recipientUserMessagesRef.updateChildValues([messageID: 1])
        }
    }
    
    func createFirebasePostEntry(thumbnailUrl: String?, fileUrl: String?, room: PublicRoom, cityAndState: String, postText: String?){
        
        if let toRoom = room.postKey{
            let itemRef = DataService.ds.REF_POSTS.childByAutoId()
            let timestamp: Int = Int(NSDate().timeIntervalSince1970)
            var messageItem: Dictionary<String,AnyObject>
            
            if let thumbUrl = thumbnailUrl{
                messageItem = ["fromId": CurrentUser._postKey as AnyObject,
                               "timestamp" : timestamp as AnyObject,
                               "toRoom": toRoom as AnyObject,
                               "mediaType": "VIDEO" as AnyObject,
                               "thumbnailUrl": thumbUrl as AnyObject,
                               "likes": 0 as AnyObject,
                               "comments": 0 as AnyObject,
                               "showcaseUrl": fileUrl as AnyObject,
                               "authorName": CurrentUser._userName as AnyObject,
                               "authorPic": CurrentUser._profileImageUrl as AnyObject,
                               "cityAndState": cityAndState as AnyObject]
            }else if fileUrl != nil && thumbnailUrl == nil{
                messageItem = ["fromId": CurrentUser._postKey as AnyObject,
                               "timestamp" : timestamp as AnyObject,
                               "toRoom": toRoom as AnyObject,
                               "mediaType": "PHOTO" as AnyObject,
                               "likes": 0 as AnyObject,
                               "comments": 0 as AnyObject,
                               "showcaseUrl": fileUrl! as AnyObject,
                               "authorName": CurrentUser._userName as AnyObject,
                               "authorPic": CurrentUser._profileImageUrl as AnyObject,
                               "cityAndState": cityAndState as AnyObject]
            }else{
                messageItem = ["fromId": CurrentUser._postKey as AnyObject,
                               "timestamp" : timestamp as AnyObject,
                               "toRoom": toRoom as AnyObject,
                               "mediaType": "TEXT" as AnyObject,
                               "likes": 0 as AnyObject,
                               "comments": 0 as AnyObject,
                               "authorName": CurrentUser._userName as AnyObject,
                               "authorPic": CurrentUser._profileImageUrl as AnyObject,
                               "cityAndState": cityAndState as AnyObject]
            }
            
            if let unwrappedText = postText{
                messageItem["postText"] = unwrappedText as AnyObject
            }
            
            
            itemRef.updateChildValues(messageItem) { (error, ref) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }
                
                let postRoomRef = self.REF_POSTSPERROOM.child(toRoom)
                let postID = itemRef.key
                postRoomRef.updateChildValues([postID: 1])
            }
        }
    }
    
    func createFirebaseUserEntry(values:[String: String], profileImageUrl: String){
        print("I am inside createFireBase user")
        for (key, value) in values{
            REF_USER_CURRENT.child(key).setValue(value)
        }
        REF_USER_CURRENT.child("ProfileImage").setValue(profileImageUrl)
        if let userName = values["UserName"]{
            let firstLetter = String(userName.uppercased()[userName.startIndex])
            let userNameRef = REF_USERS_NAMES.child(firstLetter)
                userNameRef.updateChildValues([userName.lowercased(): 1])
        }
    }
    
    func updateProfilePic(profilePic: String){
        let userRef = REF_USER_CURRENT.child("ProfileImage")
            userRef.setValue(profilePic)
    }
    
    func deletePostFromFirebase(postToDelete: UserPost){
        let commentsPostRef = REF_POST_COMMENTS.child(postToDelete.postKey!)
            commentsPostRef.observe(.value, with: {snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                    for snap in snapshots{
                        DataService.ds.REF_USERS_COMMENTS.child(snap.key).removeValue()
                        commentsPostRef.child(snap.key).removeValue()
                    }
                }
            }, withCancel: nil)
        REF_POSTS.child(postToDelete.postKey!).removeValue()
        REF_POSTSPERROOM.child(postToDelete.toRoom!).child(postToDelete.postKey!).removeValue()
        
        let publicRoomRef = REF_CHATROOMS.child(postToDelete.toRoom!)
        publicRoomRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let numOfPosts = dictionary["posts"] as! Int - 1
                let adjustedPosts = NSNumber(value: Int32(numOfPosts))
                publicRoomRef.child("posts").setValue(adjustedPosts)
            }
        }, withCancel: nil)
    }

    private func thumbnailImageForVideoUrl(videoUrl: NSURL) -> UIImage?{
        let asset = AVAsset(url: videoUrl as URL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do{
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            
            return UIImage(cgImage: thumbnailCGImage)
        }catch let err{
            print(err)
        }
        return nil
    }
 
}//end DataService Class
