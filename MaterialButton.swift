//
//  MaterialButton.swift
//  ChatHook
//
//  Created by Kevin Farm on 5/10/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import Foundation
import UIKit

class MaterialButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = PLAYLIFE_COLOR
        backgroundColor = UIColor(r: 80, g: 101, b: 161)
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont(name: FONT_AVENIR_MEDIUM, size: 18.0)

        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)

    }
    
}
