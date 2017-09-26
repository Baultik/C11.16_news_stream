//
//  Database.swift
//  Streamism
//
//  Created by Brian Ault on 8/21/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol StreamDatabaseDelegate {
    func streamDataUpdate(_ streamData:StreamList?)
    //func update(streamData:[[String:AnyObject]])
}

class StreamDatabase {
    private var ref: DatabaseReference!
    private var handle:UInt = 0
    private(set) var rawData:[String:AnyObject]?
    private(set) var categoryData:StreamCategoryList?
    private(set) var streamData:StreamList?
    var delegate:StreamDatabaseDelegate?
    
    init() {
        ref = Database.database().reference(withPath: "-KbHuqtKNuu96svHRgjz")
    }
    
    func startUpdates() {
        if (handle > 0) {return}
        handle = ref.observe(.value, with: { (snapshot) in
            //print("Streamism data - \(String(describing: snapshot.value))")
//            let methodStart = Date()
            self.rawData = snapshot.value as? [String : AnyObject] ?? [:]
            let cats = self.rawData?["streams"] as? [[String: AnyObject]] ?? [[:]]
            self.categoryData = self.parse(rawData: cats)
            self.streamData = self.categoryData?.streamList
            //let streams:[[String:AnyObject]] = self.parse(rawData: cats)
            if let delegate = self.delegate {
                delegate.streamDataUpdate(self.streamData)
            }
//            let methodEnd = Date()
//            let time = methodEnd.timeIntervalSince(methodStart)
//            print("time: \(time)")
        })
    }
    
    func stopUpdates() {
        ref.removeObserver(withHandle: handle)
    }
    
    private func parse(rawData:[[String: AnyObject]]) -> StreamCategoryList {
        var cats = [StreamCategory]()
        
        for category in rawData {
            let cat = category["id"] as? String
            let streams = category["streams"] as? [[String:AnyObject]]
            let streamCat = StreamCategory(type:StreamCategoryType(rawValue: cat!)!,data:streams!)
            cats.append(streamCat)
        }
        
        return StreamCategoryList(categoryData: cats)
    }
    
    private func parse(rawData:[[String: AnyObject]]) -> [[String:AnyObject]] {
        //get max length
        var maxCount = 0
        
        for category in rawData {
            //let cat = category["id"] as? String
            let streams = category["streams"] as? [[String:AnyObject]]
            if (streams?.count)! > maxCount {
                maxCount = (streams?.count)!
            }
        }
        
        var filteredList = [[String:AnyObject]]()
        
        for j in 0..<maxCount {
            var sub = [[String:AnyObject]]();
            
            //Sort 1 of each cat at a time - better way?
            //go through each category - make temp array holding count element of each
            for k in 0..<rawData.count {
                let category = rawData[k]
                let streams = category["streams"] as? [[String:AnyObject]]
                if (streams?.count)! > j  {
                    let stream = streams?[j]
                    sub.append(stream!)
                }
            }
            
            //random sort temp array
            //add array elements to final list
            if (sub.count > 0) {
                sub.sort(by: { (stream1, stream2) -> Bool in
                    return arc4random_uniform(2) == 0
                })
                filteredList.append(contentsOf: sub)
            }
        }
        return filteredList
    }
}
