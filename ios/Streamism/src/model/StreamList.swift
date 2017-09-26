//
//  StreamList.swift
//  Streamism
//
//  Created by Brian Ault on 9/1/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import Foundation

class StreamList {
    private var streamData:[Stream]
    var count:Int {
        return streamData.count
    }
    
    init(streamData:[Stream]) {
        self.streamData = streamData
    }
    
    subscript(index:Int) -> Stream {
        return self.streamData[index]
    }
    
    func filter(by preference:StreamCategoryPreference) -> StreamList {
        let data =  streamData.filter({ (stream) -> Bool in
            let hasType = preference.hasType(StreamCategoryType(rawValue: stream.category)!)
            if hasType {print("type: \(stream.category)")}
            return hasType
        })
        
        return StreamList(streamData: data)
    }
}
