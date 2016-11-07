//
//  CurrentUser.swift
//  ChatHook
//
//  Created by Kevin Farm on 9/15/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

struct CurrentUser{
    static var _userName: String!
    static var _profileImageUrl: String!
    static var _postKey: String!
    static var _postRef: FIRDatabaseReference!
    static var _email: String!
    static var _location: CLLocation!
    static var _blockedUsersArray: [String]?
    static var _amIBlocked: Bool = false
}
