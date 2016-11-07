//
//  Extensions.swift
//  GameOfChats
//
//  Created by Kevin Farm on 8/17/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit
import FirebaseStorage
import AVFoundation

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView{
    func loadImageUsingCacheWithUrlString(urlString: String){
        
        self.image = nil
        
        //check cache for image first
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as UIImage?{
            print("I got image from the CACHED")
            self.image = cachedImage
            return
        }
        
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!){
                    print("I downloaded the IMAGE BITCH")
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
}

extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}




