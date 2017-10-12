//
//  TestStreamCategoryList.swift
//  StreamismTests
//
//  Created by Brian Ault on 10/12/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import XCTest
@testable import Streamism

class TestStreamCategoryList: XCTestCase {
    var catList:StreamCategoryList!
    var catGaming:StreamCategory!
    var catEnt:StreamCategory!
    
    override func setUp() {
        super.setUp()
        catGaming = StreamCategory(type: .Gaming, data: [["category":"gaming" as AnyObject,
                                                    "channel":"yo" as AnyObject,
                                                    "embedChat":"hi" as AnyObject,
                                                    "embedVideo":"hey" as AnyObject,
                                                    "id":"that" as AnyObject,
                                                    "source":"there" as AnyObject,
                                                    "thumbnail":"pic" as AnyObject,
                                                    "title":"this" as AnyObject]])
        catEnt = StreamCategory(type: .Entertainment, data: [["category":"entertainment" as AnyObject,
                                                                 "channel":"yo" as AnyObject,
                                                                 "embedChat":"hi" as AnyObject,
                                                                 "embedVideo":"hey" as AnyObject,
                                                                 "id":"that" as AnyObject,
                                                                 "source":"there" as AnyObject,
                                                                 "thumbnail":"pic" as AnyObject,
                                                                 "title":"this" as AnyObject],
                                                                 ["category":"entertainment" as AnyObject,
                                                                  "channel":"yo2" as AnyObject,
                                                                  "embedChat":"hi" as AnyObject,
                                                                  "embedVideo":"hey" as AnyObject,
                                                                  "id":"that" as AnyObject,
                                                                  "source":"there" as AnyObject,
                                                                  "thumbnail":"pic" as AnyObject,
                                                                  "title":"this" as AnyObject]])
        catList = StreamCategoryList(categoryData: [catGaming,catEnt])
    }
    
    override func tearDown() {
        catGaming = nil
        catEnt = nil
        catList = nil
        super.tearDown()
    }
    
    func testShuffle() {
        
    }
    
}
