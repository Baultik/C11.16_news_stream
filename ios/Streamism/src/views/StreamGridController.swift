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
    private var collectionStreamList:StreamList?//currently displayed - filtered
    private var pendingStreamList:StreamList?//new stream data - not filtered
    private var fullStreamList:StreamList?//full stream data currently shown - not filtered
    
    //TODO: figure out best way to get preference data
    private var preference:StreamCategoryPreference = StreamCategoryPreference.all()

    override func viewDidLoad() {
        super.viewDidLoad()
        dbs = StreamDatabase()
        dbs?.delegate = self
        dbs?.startUpdates()
        
        streamFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        streamFlowLayout.minimumInteritemSpacing = 0
        streamFlowLayout.minimumLineSpacing = 0
        collectionView?.collectionViewLayout = streamFlowLayout
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateStreamGrid(streamData:StreamList?) {
        if let pending = streamData {
            guard let collect = collectionStreamList else {
                collectionStreamList = streamData
                collectionView?.reloadData()
                return
            }
            
            let add = pending.count > collect.count
            let indexes = compare(oldStreamData: collect,newStreamData: pending)
            
            collectionView?.performBatchUpdates({ 
                self.collectionStreamList = streamData
                if add {
                    self.collectionView?.insertItems(at: indexes)
                } else {
                    self.collectionView?.deleteItems(at: indexes)
                }
            }, completion: { (done) in
                //done changing items
                //re-enable changing categories
            })
        }
    }
    
    private func updateGrid() {
        //update whats displayed with filtered version of full data
        let data = fullStreamList?.filter(by: preference)
        updateStreamGrid(streamData:data)
    }
    
    @objc private func updateWithPendingData() {
        navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
        if let pending = pendingStreamList {
            fullStreamList = pending
            pendingStreamList = nil
            collectionStreamList = nil
            updateGrid()
        }
    }
    
    private func compare(oldStreamData:StreamList,newStreamData:StreamList) -> [IndexPath] {
        var indexes = [IndexPath]()
        var offset = 0
        var i = 0
        
        while i < min(oldStreamData.count,newStreamData.count) {
            if oldStreamData.count < newStreamData.count {
                if oldStreamData[i].streamID != newStreamData[i+offset].streamID {
                    indexes.append(IndexPath(row: i+offset, section: 0))
                    offset += 1
                    continue
                }
            } else if oldStreamData.count > newStreamData.count {
                if oldStreamData[i+offset].streamID != newStreamData[i].streamID {
                    indexes.append(IndexPath(row: i+offset, section: 0))
                    offset += 1
                    continue
                }
            }
            i += 1
        }
        
        
        return indexes
    }
    
    func streamDataUpdate(_ streamData:StreamList?) {
        pendingStreamList = streamData
        if collectionStreamList == nil {
            //if no data currenly being shown update immedietely
            updateWithPendingData()
        } else {
            //show notification that new streams are available
            let up = UIBarButtonItem(title: "!", style: .plain, target: self, action: #selector(StreamGridController.updateWithPendingData))
            navigationController?.navigationBar.topItem?.rightBarButtonItem = up
        }
    }
    
    func preferenceUpdate(_ preference:StreamCategoryPreference) {
        self.preference = preference
        updateGrid()
    }

    // MARK: - Collection
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let collect = collectionStreamList {
            return collect.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Stream", for: indexPath) as! StreamGridCell
        if let collect = collectionStreamList {
            let stream = collect[indexPath.row]
            cell.title = stream.title
            cell.name = stream.channel
            cell.loadImage(from: stream.thumbnail)
        }

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
