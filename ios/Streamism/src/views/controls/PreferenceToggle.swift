//
//  PreferenceToggle.swift
//  Streamism
//
//  Created by Brian Ault on 9/29/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import UIKit

class PreferenceToggle: UIControl {
    private var iconImageView = UIImageView()
    private var prefLabel = UILabel()
    
    @IBInspectable var image:UIImage? {
        didSet {
            iconImageView.image = image
        }
    }
    @IBInspectable var text:String? {
        didSet {
            prefLabel.text = text
        }
    }
//    @IBInspectable var padding:CGFloat = 7
    @IBInspectable var font = UIFont.systemFont(ofSize: 10.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let height:CGFloat = ceil(self.bounds.height / 3)
        
//        iconImageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - height)
//        iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        iconImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        iconImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

//        prefLabel.frame = CGRect(x: 0, y: self.bounds.height - height, width: self.bounds.width, height: height)
        addSubview(prefLabel)
        prefLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: prefLabel.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: prefLabel.bottomAnchor).isActive = true
        prefLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        prefLabel.backgroundColor = UIColor.cyan
        iconImageView.backgroundColor = UIColor.purple
        
//        addSubview(iconImageView)
    }
    

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        var textRect = CGRect.zero
//        if let text = text {
//            let size:CGSize = text.size(withAttributes: [NSAttributedStringKey.font: font])
//            textRect = CGRect(x: self.bounds.midX - ceil(size.width / 2),
//                               y: self.bounds.maxY - ceil(size.height) - padding,
//                               width: ceil(size.width),
//                               height: ceil(size.height))
//
//            text.draw(in: textRect, withAttributes: [NSAttributedStringKey.font:font])
//        }
//
//
//
//        if let image = image {
//            let ratio = image.size.width / image.size.height
//            let height = self.bounds.height - textRect.height - padding * 3
//            let width = ratio * height
//            let imageRect = CGRect(x: self.bounds.midX - width / 2,
//                                   y: padding,
//                                   width: width,
//                                   height: height)
//            image.draw(in: imageRect, blendMode: CGBlendMode.color, alpha: 1)
//        }
//    }
}
