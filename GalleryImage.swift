//
//  GalleryImage.swift
//  ChatHook
//
//  Created by Kevin Farm on 9/13/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit

class GalleryImage: NSObject {
    var postKey: String?
    var fromId: String?
    var mediaType: String?
    var galleryImageUrl: String?
    var galleryVideoUrl: String?
    var timestamp: NSNumber?
    
    init(key: String){
        postKey = key
    }
}
