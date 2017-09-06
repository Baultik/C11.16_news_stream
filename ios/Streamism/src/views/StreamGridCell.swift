//
//  StreamGridCell.swift
//  Streamism
//
//  Created by Brian Ault on 8/16/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import UIKit

class StreamGridCell: UICollectionViewCell {
    @IBOutlet weak var streamCellImageView: UIImageView!
    @IBOutlet weak var streamCellTitle: UILabel!
    @IBOutlet weak var streamCellName: UILabel!
    
    private var session:URLSession?
    
    var title:String? {
        get {
            return streamCellTitle.text
        }
        set {
            streamCellTitle.text = newValue
        }
    }
    
    var name:String? {
        get {
            return streamCellName.text
        }
        set {
            streamCellName.text = newValue
        }
    }
 
    func loadImage(from url:String) {
        cancelImageLoad()
        session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        if let url = URL(string: url) {
            (session?.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error \(error)")
                } else if let data = data {
                    DispatchQueue.main.async {
                        self.streamCellImageView.image = UIImage(data: data)
                    }
                }
            })?.resume()
        }
    }
    
    func cancelImageLoad() {
        if let session = self.session {
            session.invalidateAndCancel()
        }
    }
}
