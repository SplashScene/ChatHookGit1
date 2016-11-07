//
//  Message.swift
//  ChatHook
//
//  Created by Kevin Farm on 8/18/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    var imageUrl: String?
    var mediaType: String?
    var thumbnailUrl: String?
    var isFromBlockedUser: Bool?
    
    func chatPartnerID() -> String?{
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId! : fromId!
    }
    
}
