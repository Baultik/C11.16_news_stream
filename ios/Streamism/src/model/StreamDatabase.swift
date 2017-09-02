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
    func update(streamData:StreamList?)
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
            
            self.rawData = snapshot.value as? [String : AnyObject] ?? [:]
            let cats = self.rawData?["streams"] as? [[String: AnyObject]] ?? [[:]]
            self.categoryData = self.parse(rawData: cats)
            self.streamData = self.categoryData?.streamList
            if let delegate = self.delegate {
                delegate.update(streamData: self.streamData)
            }
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
}
