//
//  Stream.swift
//  Streamism
//
//  Created by Brian Ault on 8/15/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import Foundation

struct Stream {
    var category:String
    var channel:String
    var embedChat:String
    var embedVideo:String
    var streamID:String
    var link:String?
    var source:String
    var startTime:Date?
    var thumbnail:String
    var title:String
    var viewers:Int?
    
    init(category:String,channel:String,embedChat:String,embedVideo:String,streamID:String,source:String,thumbnail:String,title:String) {
        self.category = category
        self.channel = channel
        self.embedChat = embedChat
        self.embedVideo = embedVideo
        self.streamID = streamID
        self.source = source
        self.thumbnail = thumbnail
        self.title = title
    }
}
