//
//  UserPost.swift
//  ChatHook
//
//  Created by Kevin Farm on 8/24/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit
import Firebase

class UserPost: NSObject {
    var postKey: String?
    var fromId: String?
    var postText: String?
    var timestamp: NSNumber?
    var toRoom: String?
    var likes: NSNumber!
    var comments: NSNumber!
    var thumbnailUrl: String?
    var showcaseUrl: String?
    var mediaType: String?
    var authorPic: String?
    var authorName: String?
    var cityAndState: String?
    var postRef: FIRDatabaseReference!
    
    init(key: String){
        postKey = key
        self.postRef = DataService.ds.REF_POSTS.child(self.postKey!)
    }
    
    func adjustLikes(addLike: Bool){
        var intLikes = Int(likes)
        if intLikes == 0 {
            intLikes = addLike ? intLikes + 1 :  intLikes
        }else{
            intLikes = addLike ? intLikes + 1 :  intLikes - 1
        }
        let adjustedLikes = NSNumber(value: Int32(intLikes))
        postRef.child("likes").setValue(adjustedLikes)
    }
    
    func adjustComments(){
        let intComments = Int(comments) + 1
        let adjustedComments = NSNumber(value: Int32(intComments))
        postRef.child("comments").setValue(adjustedComments)
    }

}
