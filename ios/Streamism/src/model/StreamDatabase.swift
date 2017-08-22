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
    var handle:UInt
    
    init() {
        ref = Database.database().reference(withPath: "-KbHuqtKNuu96svHRgjz")
        handle = ref.observe(.value, with: { (snapshot) in
            //print("Streamism data - \(String(describing: snapshot.value))")
            let dict = snapshot.value as? [String : AnyObject] ?? [:]
            for category in dict["streams"] as! [[String:String]] {
                var cat = category["id"]
                var streams = category["streams"]
            }
        })
    }
}
