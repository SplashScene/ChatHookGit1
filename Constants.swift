//
//  Constants.swift
//  driveby_Showcase
//
//  Created by Kevin Farm on 4/12/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

let FONT_AVENIR_LIGHT = "Avenir-Light"
let FONT_AVENIR_MEDIUM = "Avenir-Medium"
let FONT_AVENIR_BLACK = "Avenir-Black"
let FONT_AVENIR_HEAVY = "Avenir-Heavy"
let FONT_AVENIR_BOOK_OBILIQUE = "Avenir-BookOblique"

let COPY_RATE_YES = "Rate PlayLife"
let COPY_RATE_REMIND = "Maybe Later"
let COPY_RATE_NO = "Submit Feedback"

let COPY_CAMERA_IN_PROGRESS_TITLE = "Event in Progress"
let COPY_CAMERA_IN_PROGRESS_PREFIX = "You currently have an event in progress"
let COPY_CAMERA_IN_PROGRESS_SUFFIX = ". Are you sure?"
let COPY_CAMERA_IN_PROGRESS_CONFIRM = "Create New Event"
let COPY_CAMERA_IN_PROGRESS_CANCEL = "Cancel"

let COPY_MY_EVENT_DELETE_TITLE = "Please Confirm"
let COPY_MY_EVENT_DELETE_PREFIX = "This will permanently delete"
let COPY_MY_EVENT_DELETE_SUFFIX = ". Are you sure?"
let COPY_MY_EVENT_DELETE_CONFIRM = "Delete Event"
let COPY_MY_EVENT_DELETE_CANCEL = "Cancel"

let COPY_NO_EVENTS = "There are no Plays in your area \n at the moment. Create one!"
let COPY_NO_USER_EVENTS = "You do not have any active events"
let COPY_NO_EVENTS_CREATE_TITLE = "CREATE EVENT"

let COPY_REGISTER_WEB_TERMS_TITLE = "TERMS & CONDITIONS"
let COPY_REGISTER_WEB_PRIVACY_TITLE = "PRIVACY POLICY"

let COPY_REGISTER_BTN_TERMS = "terms"
let COPY_REGISTER_BTN_PRIVACY = "privacy"

let COPY_REGISTER_BTN_GENDER_MALE = "MALE"
let COPY_REGISTER_BTN_GENDER_FEMALE = "FEMALE"

let COPY_MENU_INVITE_SMS_BODY = "Download PlayLife today and be spontaneous with people in your area!"
let COPY_EVENT_POST_INVITE_SMS_BODY = "I just posted a Play on PlayLife. Click the link to join me - let's be spontaneous!"
let COPY_EVENT_JOIN_INVITE_SMS_BODY = "I just joined a Play on PlayLife. Click the link to join me - let's be spontaneous!"

let COPY_EVENT_POST_INVITE_FACEBOOK_TITLE = "I just posted a Play on PlayLife."
let COPY_EVENT_POST_INVITE_FACEBOOK_BODY = "who wants to join me?"
let COPY_EVENT_JOIN_INVITE_FACEBOOK_TITLE = "Check out this Play on PlayLife."
let COPY_EVENT_JOIN_INVITE_FACEBOOK_BODY = "I'm going, who wants to join me?"

let COPY_MENU_INVITE_EMAIL_SUBJECT = "PlayLife App Feedback"
let COPY_MENU_INVITE_EMAIL_BODY = "This is the template for the default feedback email in PlayLife app."

let COPY_BLOCK_EVENT_ALERT_TITLE = "Report Event"
let COPY_BLOCK_EVENT_ALERT_MESSAGE = "Please provide a reason for reporting this event:"
let COPY_BLOCK_EVENT_ALERT_BUTTON = "Report"

let COPY_BLOCK_USER_ALERT_TITLE = "Block User"
let COPY_BLOCK_USER_ALERT_MESSAGE = "Please provide a reason for blocking this user:"
let COPY_BLOCK_USER_ALERT_BUTTON = "Report"

let COPY_ERROR_ALERT_TITLE = "Error"

let COPY_PERMISSION_ALERT_TITLE = "Permission Error"
let COPY_PERMISSION_ALERT_MESSAGE = "Please allow access to the camera to use this feature. Camera permissions are located in the settings for this app."
let COPY_MEDIA_PERMISSION_ALERT_MESSAGE = "Please allow access to the photo library to use this feature. Library permissions are located in the settings for this app."

let COPY_SERVER_CONNECTION_ERROR = "Error connecting to server. Please try again."

let kCellWidth = 50

let PLAYLIFE_COLOR: UIColor = UIColor(red: 184.0/255.0, green: 164.0/255.0, blue: 100.0/255.0, alpha: 1.0)
let TEXTFIELD_BACKGROUND_COLOR = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
let SHADOW_COLOR: CGFloat = 157.0/255.0


let MARGIN: CGFloat = 15.0

//Authentication
//ImageShack

let KEY_UID = "uid"
let USER_EMAIL = "userEmail"

//Imagga

//Firebase Storage Constants
let URL_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

let GALLERY_IMAGES = "gallery_images"
let MESSAGE_IMAGES = "message_images"
let POST_IMAGES = "post_images"
let PROFILE_IMAGES = "profile_images"


//Status Codes
let STATUS_ACCOUNT_NONEXIST = 17011
let STATUS_ACCOUNT_WRONGPASSWORD = 17009
let STATUS_ACCOUNT_WEAKPASSWORD = 17026
let STATUS_NO_INTERNET = 17020
let STATUS_ACCOUNT_BADEMAIL = 17008


typealias DownloadComplete = () -> ()
