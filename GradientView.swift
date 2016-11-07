//
//  GradientView.swift
//  Wallpapers
//
//  Created by Mic Pringle on 09/01/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class GradientView: UIView {
  
    lazy private var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
            layer.colors = [UIColor.clear.cgColor, UIColor(white: 0.0, alpha: 0.75).cgColor]
            layer.locations = [NSNumber(value: 0.0), NSNumber(value: 1.0)]
        return layer
    }()
  
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
     
    override init(frame: CGRect) {
         super.init(frame: frame)
         backgroundColor = UIColor.clear
         layer.addSublayer(gradientLayer)
    }

  override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
  }
  
}
