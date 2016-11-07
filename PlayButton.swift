//
//  PlayButton.swift
//  ChatHook
//
//  Created by Kevin Farm on 9/9/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import Foundation
import UIKit

class PlayButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let image = UIImage(named: "playButton")
        
        translatesAutoresizingMaskIntoConstraints = false
        setImage(image, for: .normal)
    }
    
}
