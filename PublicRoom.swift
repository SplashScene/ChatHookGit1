//
//  Post.swift
//  ChatHook
//
//  Created by Kevin Farm on 5/23/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import Foundation
import Firebase

class PublicRoom: NSObject{
    var postKey: String?
    var Author: String?
    var AuthorID: String?
    var AuthorPic: String?
    var RoomName: String?
    var timestamp: NSNumber?
    var posts: NSNumber?
    var roomRef: FIRDatabaseReference
    
    init(key: String){
        postKey = key
        roomRef = DataService.ds.REF_CHATROOMS.child(postKey!)
    }
}

