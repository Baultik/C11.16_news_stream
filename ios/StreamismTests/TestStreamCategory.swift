//
//  TestStreamCategory.swift
//  StreamismTests
//
//  Created by Brian Ault on 10/12/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import XCTest
@testable import Streamism
class TestStreamCategory: XCTestCase {
    var cat:StreamCategory!
    
    override func setUp() {
        super.setUp()
        cat = StreamCategory(type: .Gaming, data: [["category":"yo" as AnyObject,
                                                    "channel":"yo" as AnyObject,
                                                    "embedChat":"hi" as AnyObject,
                                                    "embedVideo":"hey" as AnyObject,
                                                    "id":"that" as AnyObject,
                                                    "source":"there" as AnyObject,
                                                    "thumbnail":"pic" as AnyObject,
                                                    "title":"this" as AnyObject]])
    }
    
    override func tearDown() {
        cat = nil
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(cat)
        XCTAssertNotNil(cat.streams)
    }
}
