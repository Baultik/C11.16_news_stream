//
//  TestStreamList.swift
//  StreamismTests
//
//  Created by Brian Ault on 10/17/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import XCTest
@testable import Streamism
class TestStreamList: XCTestCase {
    var list:StreamList!
    var pref:StreamCategoryPreference!
    override func setUp() {
        super.setUp()
        let s1 = Streamism.Stream(category: "gaming", channel: "", embedChat: "", embedVideo: "", streamID: "", source: "", thumbnail: "", title: "")
        let s2 = Streamism.Stream(category: "people", channel: "", embedChat: "", embedVideo: "", streamID: "", source: "", thumbnail: "", title: "")
        list = StreamList(streamData: [s1,s2])
        pref = StreamCategoryPreference()
        pref.addType(.Gaming)
    }
    
    override func tearDown() {
        list = nil
        super.tearDown()
    }
    
    func testFilter() {
        let newList = list.filter(by: pref)
        XCTAssertEqual(newList.count, 1)
    }
}
