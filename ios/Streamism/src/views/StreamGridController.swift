//
//  StreamGridController.swift
//  Streamism
//
//  Created by Brian Ault on 8/15/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import UIKit

class StreamGridController: UICollectionViewController {
    
    let streamFlowLayout = StreamFlowLayout(columns: 2)
    let dbs = StreamDatabase()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        streamFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        streamFlowLayout.minimumInteritemSpacing = 0
        streamFlowLayout.minimumLineSpacing = 0
        collectionView?.collectionViewLayout = streamFlowLayout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Stream", for: indexPath) as! StreamGridCell
        //cell.loadImage(from: "")
        return cell
    }
    
    override func collectionView(_ collectionView:UICollectionView, didEndDisplaying cell:UICollectionViewCell, forItemAt indexPath:IndexPath) {
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
