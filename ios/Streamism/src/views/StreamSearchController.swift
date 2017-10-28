//
//  StreamSearchController.swift
//  Streamism
//
//  Created by Brian Ault on 10/27/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import UIKit

class StreamSearchController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private var collectionStreamList:StreamList?//currently displayed - filtered
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let collect = collectionStreamList {
            return collect.count
        }
        return 0
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Stream", for: indexPath) as! StreamGridCell
        if let collect = collectionStreamList {
            let stream = collect[indexPath.row]
            cell.title = stream.title
            cell.name = stream.channel
            cell.loadImage(from: stream.thumbnail)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView:UICollectionView, didEndDisplaying cell:UICollectionViewCell, forItemAt indexPath:IndexPath) {
        let cell = cell as! StreamGridCell
        cell.cancelImageLoad()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
