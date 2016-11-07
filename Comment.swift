//
//  Comment.swift
//  ChatHook
//
//  Created by Kevin Farm on 8/24/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit
import Firebase

class Comment: NSObject {
    var commentKey: String?
    var fromId: String?
    var commentText: String?
    var timestamp: NSNumber?
    var toPost: String?
    var likes: NSNumber!
    var commentRef: FIRDatabaseReference!
    var authorPic: String?
    var authorName: String?
    var cityAndState: String?
    
    init(key: String){
        commentKey = key
        self.commentRef = DataService.ds.REF_USERS_COMMENTS.child(self.commentKey!)
    }
    
    func adjustLikes(addLike: Bool){
        var intLikes = Int(likes)
        if intLikes == 0 {
            intLikes = addLike ? intLikes + 1 :  intLikes
        }else{
            intLikes = addLike ? intLikes + 1 :  intLikes - 1
        }
        let adjustedLikes = NSNumber(value: Int32(intLikes))
        commentRef.child("likes").setValue(adjustedLikes)
    }
    
}

