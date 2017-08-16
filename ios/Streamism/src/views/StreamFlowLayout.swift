//
//  StreamFlowLayout.swift
//  Streamism
//
//  Created by Brian Ault on 8/15/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import UIKit

class StreamFlowLayout: UICollectionViewFlowLayout {
    private var ratio:CGFloat = 9/16
    var columns:Int = 1
    override var itemSize: CGSize {
        get {
            guard let collectionView = collectionView else {
                return super.itemSize
            }
            let width:CGFloat = (collectionView.bounds.size.width / CGFloat(columns)).rounded()
            return CGSize(width: width, height: (width * ratio).rounded())
        }
        set {
            super.itemSize = newValue
        }
    }
    
    init(columns:Int) {
        self.columns = columns
        super.init()        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds != collectionView?.bounds
        return context
    }
}
