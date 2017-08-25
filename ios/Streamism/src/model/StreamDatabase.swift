//
//  Database.swift
//  Streamism
//
//  Created by Brian Ault on 8/21/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import Foundation
import FirebaseDatabase


class StreamDatabase {
    var ref: DatabaseReference!
    var handle:UInt = 0
    private var masterList = [StreamCategory]()
    
    init() {
        ref = Database.database().reference(withPath: "-KbHuqtKNuu96svHRgjz")
        handle = ref.observe(.value, with: { (snapshot) in
            //print("Streamism data - \(String(describing: snapshot.value))")

            let value = snapshot.value as? [String : AnyObject] ?? [:]
            let cats = value["streams"] as? [[String: AnyObject]] ?? [[:]]
            for category in cats {
                let cat = category["id"] as? String
                let streams = category["streams"] as? [[String:String]]
                let streamCat = StreamCategory(type:StreamCategoryType(rawValue: cat!)!,data:streams!)
                self.masterList.append(streamCat)
            }
        })
    }
    
    
    
    private func shuffle(list:[StreamCategory], categories:[StreamCategoryType]) -> [Stream] {
        var filteredList = [Stream]()
        var filteredCats = [StreamCategory]()
        
        //filter out cats if necessary - assumes one of each type in the array
        for type in categories {
            for cat in list {
                if type.rawValue == cat.type.rawValue {
                    filteredCats.append(cat)
                }
            }
        }
        
        //get max length
        var maxCount = 0
        for cat in filteredCats {
            if cat.streams.count > maxCount {
                maxCount = cat.streams.count
            }
        }
        
        
        for j in 0..<maxCount {
            var sub = [Stream]();
            
            //Sort 1 of each cat at a time - better way?
            //go through each category - make temp array holding count element of each
            for k in 0..<filteredCats.count {
                let category = filteredCats[k];
                if category.streams.count > j  {
                    sub.append(category.streams[j])
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
