//
//  PreferenceToggle.swift
//  Streamism
//
//  Created by Brian Ault on 9/29/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import UIKit

@IBDesignable class PreferenceToggle: UIControl {
    private var imageView = UIImageView()
    private var label = UILabel()
    
    @IBInspectable var image:UIImage? {
        didSet {
            imageView.image = image
        }
    }
    @IBInspectable var text:String? {
        didSet {
            label.text = text
        }
    }

    @IBInspectable var fontSize:CGFloat = 10 {
        didSet {
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    @IBInspectable var activeColor:UIColor = UIColor.clear {
        didSet{
            
        }
    }
    
    @IBInspectable var isOn:Bool = true {
        didSet {
            self.backgroundColor = isOn ? activeColor : UIColor.white
        }
    }
    
    var categoryType:StreamCategoryType = .Gaming
    
    // IB: use the adapter
    @IBInspectable var categoryTypeAdapter:String {
        get {
            return self.categoryType.rawValue
        }
        set(catType) {
            self.categoryType = StreamCategoryType(rawValue: catType)!
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.clipsToBounds = true;
//        label.backgroundColor = UIColor.cyan
//        imageView.backgroundColor = UIColor.purple
        
        imageView.contentMode = .scaleAspectFit
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textAlignment = .center
        
        addSubview(label)
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        let margins = self.layoutMarginsGuide
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        //height of this view is animated with it's parent stack view inside vc view
        //set priority lower than required to avoid conflict
        let lc = label.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        lc.priority = UILayoutPriority.defaultHigh
        lc.isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: label.topAnchor).isActive = true
        
        super.layoutSubviews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}
