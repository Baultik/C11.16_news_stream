//
//  StreamismTests.swift
//  StreamismTests
//
//  Created by Brian Ault on 8/9/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import XCTest
import Firebase
@testable import Streamism

class TestStream: XCTestCase {
    var stream:Streamism.Stream!
    
    override func setUp() {
        super.setUp()
         stream = Streamism.Stream(category: "gaming", channel: "lirik", embedChat: "chat", embedVideo: "twitch", streamID: "lirik", source: "twitch", thumbnail: "thumb", title: "doin the do")
    }
    
    override func tearDown() {
        stream = nil
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(stream)
    }
}
