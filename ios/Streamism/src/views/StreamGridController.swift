//
//  StreamGridController.swift
//  Streamism
//
//  Created by Brian Ault on 8/15/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import UIKit

class StreamGridController: UICollectionViewController,StreamDatabaseDelegate {
    
    private let streamFlowLayout = StreamFlowLayout(columns: 2)
    private var dbs:StreamDatabase?
    private var collectionStreams:[Stream]?
    private var pendingStreams:[Stream]?
    private var preference:StreamCategoryPreference = StreamCategoryPreference.all()

    override func viewDidLoad() {
        super.viewDidLoad()
        dbs = StreamDatabase()
        dbs?.delegate = self
        dbs?.startObserver()
        
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
    
    private func updateStreamCollection() {
        if let pending = pendingStreams {
            guard let collect = collectionStreams else {
                collectionStreams = pendingStreams
                pendingStreams = nil
                collectionView?.reloadData()
                return
            }
            
            let add = pending.count > collect.count
            let indexes = compare(current: collect,updated: pending)
            
            collectionView?.performBatchUpdates({ 
                self.collectionStreams = self.pendingStreams
                self.pendingStreams = nil
                if add {
                    self.collectionView?.insertItems(at: indexes)
                } else {
                    self.collectionView?.deleteItems(at: indexes)
                }
            }, completion: { (done) in
                //done changing items
                //renable changing categories
            })
        }
    }
    
    func updatedStreams(streams:[Stream]) {
        pendingStreams = streams
        if collectionStreams == nil {
            updateStreamCollection()
        } else {
            //show notification that new streams are available
        }
    }
    
    func compare(current:[Stream],updated:[Stream]) -> [IndexPath] {
        var indexes = [IndexPath]()
        var offset = 0
        var i = 0
        
        while i < min(current.count,updated.count) {
            if current.count < updated.count {
                if current[i].streamID != updated[i+offset].streamID {
                    indexes.append(IndexPath(row: i+offset, section: 0))
                    offset += 1
                    continue
                }
            } else if current.count > updated.count {
                if current[i+offset].streamID != updated[i].streamID {
                    indexes.append(IndexPath(row: i+offset, section: 0))
                    offset += 1
                    continue
                }
            }
            i += 1
        }
        
        
        return indexes
    }
    
    // MARK: - Collection
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let collect = collectionStreams {
            return collect.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Stream", for: indexPath) as! StreamGridCell
        if let collect = collectionStreams {
            let stream = collect[indexPath.row]
            cell.title = stream.title
            cell.name = stream.channel
        }
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
