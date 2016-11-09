//
//  HudView.swift
//  MyLocations
//
//  Created by Kevin Farm on 4/2/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import Foundation
import UIKit

class HudView: UIView{
    var text = ""
    
    let uploadAIV: UIActivityIndicatorView = {
        let uploadSpinner = UIActivityIndicatorView()
            uploadSpinner.hidesWhenStopped = true
            uploadSpinner.activityIndicatorViewStyle = .whiteLarge
        return uploadSpinner
    }()
    
    class func hudInView(view: UIView, animated: Bool) -> HudView{
        let upAIV = UIActivityIndicatorView()
            upAIV.translatesAutoresizingMaskIntoConstraints = false
            upAIV.activityIndicatorViewStyle = .whiteLarge
            upAIV.center = view.center
            upAIV.startAnimating()
        let hudView = HudView(frame: view.bounds)
            hudView.isOpaque = false
            hudView.addSubview(upAIV)
                upAIV.centerXAnchor.constraint(equalTo: hudView.centerXAnchor).isActive = true
                upAIV.centerYAnchor.constraint(equalTo: hudView.centerYAnchor).isActive = true

        view.addSubview(hudView)
        
        view.isUserInteractionEnabled = false
        hudView.showAnimated(animated: animated)
        return hudView
    }
    
    override func draw(_ rect: CGRect) {
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        
        let boxRect = CGRect(x: round((bounds.size.width - boxWidth) / 2), y: round((bounds.size.height - boxHeight) / 2), width: boxWidth, height: boxHeight)
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
//        self.addSubview(uploadAIV)
//        uploadAIV.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        uploadAIV.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        uploadAIV.startAnimating()
        
//        if let image = UIImage(named: "Checkmark"){
//            let imagePoint = CGPoint(x: center.x - round(image.size.width / 2), y: center.y - round(image.size.height / 2) - boxHeight / 8)
//            image.draw(at: imagePoint)
//        }
        
        let attribs = [NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.white]
        let textSize = text.size(attributes: attribs)
        let textPoint = CGPoint(x: center.x - round(textSize.width / 2), y: center.y - round(textSize.height / 2) + boxHeight / 3)
        
        text.draw(at: textPoint, withAttributes: attribs)
    }
    
    func showAnimated(animated: Bool){
        alpha = 0
        transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
        }, completion: nil)
        
        /*
         UIView.animateWithDuration(0.3, animations: {
         self.alpha = 1
         self.transform = CGAffineTransformIdentity
         })
         
         The standard steps for doing UIView-based animations are as follows:
         1. Set up the initial state of the view before the animation starts. Here you set
         alpha to 0, making the view fully transparent. You also set the transform to a
         scale factor of 1.3. We’re not going to go into depth on transforms here, but
         basically this means the view is initially stretched out.
         2. Call UIView.animateWithDuration(. . .) to set up an animation. You give this a
         closure that describes the animation. Recall that a closure is a piece of inline code
         that is not executed right away. UIKit will animate the properties that you change
         inside the closure from their initial state to the final state.
         3. Inside the closure, set up the new state of the view that it should have after the
         animation completes. You set alpha to 1, which means the HudView is now fully
         opaque. You also set the transform to the “identity” transform, restoring the scale
         back to normal. Because this code is part of a closure, you need to use self to
         refer to the HudView instance and its properties. That’s the rule for closures.
         */
    }
}
