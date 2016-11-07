//
//  User.swift
//  ChatHook
//
//  Created by Kevin Farm on 7/24/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class User{
    private var _userName: String!
    private var _profileImageUrl: String?
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    private var _email: String!
    
    var userName: String { return _userName }
    var profileImageUrl: String? { return _profileImageUrl }
    var postKey: String { return _postKey }
    var email: String { return _email }
    var location: CLLocation!
    var distance: Double?
    var isBlocked: Bool! = false
    var blockedUsersArray: [String]?
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>){
        self._postKey = postKey
        
        if let profileURL = dictionary["ProfileImage"] as? String{
            self._profileImageUrl = profileURL
        }else{
            self._profileImageUrl = "http://imageshack.com/a/img922/8259/MrQ96I.png"
        }
        
        if let profileName = dictionary["UserName"] as? String{
            self._userName = profileName
        }else{
            self._userName = "AnonymousPoster"
        }
        
        if let userEmail = dictionary["Email"] as? String{
            self._email = userEmail
        }
        
        self._postRef = DataService.ds.REF_USERS.child(self._postKey)
    }
    
    func setLocationWithLatitude(lat: Double, long: Double){
        self.location = CLLocation(latitude: lat, longitude: long)
        if self.location != nil{
            print("I have set self._location")
        }else{
            print("I have NOT set self._location")
        }
    }
    
    func didIBlockThisUser(selectedUser: User){
        if let didIBlockThisUser = CurrentUser._blockedUsersArray?.contains(selectedUser.postKey){
            isBlocked = didIBlockThisUser
        }
        
    }

}//end user class
