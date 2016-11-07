//
//  MaterialTextField.swift
//  ChatHook
//
//  Created by Kevin Farm on 5/10/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import Foundation
import UIKit

class MaterialTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
        layer.backgroundColor = TEXTFIELD_BACKGROUND_COLOR.cgColor
        textColor = UIColor.darkGray
        font = UIFont(name: "FONT_ANENIR_LIGHT", size: 14.0)
        autocapitalizationType = .none
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
}
