//
//  StreamCategory.swift
//  Streamism
//
//  Created by Brian Ault on 8/21/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import Foundation

enum StreamCategoryType:String {
    case Gaming = "gaming"
    case Entertainment = "entertainment"
    case People = "people"
    case News = "news"
    case Sports = "sports"
    case Misc = "misc"
}

struct StreamCategory {
    let type:StreamCategoryType
    let streams: [Stream]
    
    init(type:StreamCategoryType, data:[[String:AnyObject]]) {
        self.type = type
        var streams = [Stream]()
        for streamData in data {
            var stream = Stream(category: streamData["category"] as! String,
                                channel: streamData["channel"] as! String,
                                embedChat: streamData["embedChat"] as! String,
                                embedVideo: streamData["embedVideo"] as! String,
                                streamID: streamData["id"] as! String,
                                source: streamData["source"] as! String,
                                thumbnail: streamData["thumbnail"] as! String,
                                title: streamData["title"] as! String)
            
            stream.link = streamData["link"] as? String
            
            if let time = streamData["startTime"] as? String{
                stream.startTime = DateFormatter().date(from: time)
            }
            
            if let viewers = streamData["viewers"] as? Int {
                stream.viewers = viewers
            }
            
            streams.append(stream)
        }
                
        self.streams = streams
    }
}
