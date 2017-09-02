//
//  StreamCategoryList.swift
//  Streamism
//
//  Created by Brian Ault on 9/1/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import Foundation

class StreamCategoryList {
    private var categoryData:[StreamCategory]
    private(set) var streamList:StreamList?
    
    init(categoryData:[StreamCategory]) {
        self.categoryData = categoryData
        self.streamList = StreamList(streamData: shuffle(categoryData: self.categoryData))
    }
    
    subscript(index:Int) -> StreamCategory {
        return categoryData[index]
    }
    
    private func shuffle(categoryData:[StreamCategory]) -> [Stream] {
        var filteredList = [Stream]()
        
        //get max length
        var maxCount = 0
        for cat in categoryData {
            if cat.streams.count > maxCount {
                maxCount = cat.streams.count
            }
        }
        
        for j in 0..<maxCount {
            var sub = [Stream]();
            
            //Sort 1 of each cat at a time - better way?
            //go through each category - make temp array holding count element of each
            for k in 0..<categoryData.count {
                let category = categoryData[k];
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
