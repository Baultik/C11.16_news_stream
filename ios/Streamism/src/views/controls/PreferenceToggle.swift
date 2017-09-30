//
//  PreferenceToggle.swift
//  Streamism
//
//  Created by Brian Ault on 9/29/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import UIKit

@IBDesignable
class PreferenceToggle: UIControl {

    @IBInspectable var image:UIImage?
    @IBInspectable var text:String?
    @IBInspectable var padding:CGFloat = 5
    @IBInspectable var font = UIFont.systemFont(ofSize: 10.0)
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        var textRect = CGRect.zero
        if let text = text {
            let size:CGSize = text.size(withAttributes: [NSAttributedStringKey.font: font])
            textRect = CGRect(x: self.bounds.midX - ceil(size.width / 2),
                               y: self.bounds.maxY - ceil(size.height) - padding,
                               width: ceil(size.width),
                               height: ceil(size.height))
            
            text.draw(in: textRect, withAttributes: [NSAttributedStringKey.font:font])
        }
        
        
        
        if let image = image {
            let ratio = image.size.width / image.size.height
            let height = self.bounds.height - textRect.height - padding * 3
            let width = ratio * height
            let imageRect = CGRect(x: self.bounds.midX - width / 2,
                                   y: padding,
                                   width: width,
                                   height: height)
            image.draw(in: imageRect, blendMode: CGBlendMode.color, alpha: 1)
        }
    }
}
