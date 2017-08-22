//
//  StreamCategory.swift
//  Streamism
//
//  Created by Brian Ault on 8/21/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import Foundation

enum StreamType:String {
    case Gaming = "gaming"
    case Entertainment = "entertainment"
    case People = "people"
    case News = "news"
    case Sports = "sports"
    case Misc = "misc"
}

struct StreamCategory {
    let type:StreamType
    let streams: [Stream]
    
    init(type:StreamType, data:[[String:String]]) {
        self.type = type
        var streams = [Stream]()
        for streamData in data {
            let stream = Stream(category: streamData["category"]!,
                                channel: streamData["channel"]!,
                                embedChat: URL(string:streamData["embedChat"]!)!,
                                embedVideo: URL(string:streamData["embedVideo"]!)!,
                                streamID: streamData["id"]!,
                                link: URL(string:streamData["link"]!)!,
                                source: streamData["source"]!,
                                startTime: DateFormatter().date(from: streamData["startTime"]!)!,
                                thumbnail: URL(string:streamData["thumbnail"]!)!,
                                title: streamData["title"]!,
                                viewers: Int(streamData["viewers"]!)!)
            streams.append(stream)
        }
                
        self.streams = streams
    }
}
