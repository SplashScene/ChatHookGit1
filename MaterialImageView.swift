//
//  MaterialImageView.swift
//  ChatHook
//
//  Created by Kevin Farm on 5/10/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit

class MaterialImageView: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        layer.cornerRadius = frame.size.width / 2
        self.clipsToBounds = true
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowColor = UIColor.black.cgColor
        self.contentMode = .scaleAspectFill 
    }

        override func awakeFromNib() {
            layer.cornerRadius = frame.size.width / 2
            self.clipsToBounds = true
            layer.shadowOpacity = 0.8
            layer.shadowRadius = 5.0
            layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            layer.shadowColor = UIColor.black.cgColor
        }
}
