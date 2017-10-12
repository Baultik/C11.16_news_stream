//
//  TestStreamCategoryPreference.swift
//  StreamismTests
//
//  Created by Brian Ault on 10/12/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import XCTest
@testable import Streamism

class TestStreamCategoryPreference: XCTestCase {
    var catPrefEmpty:StreamCategoryPreference!
    var catPrefAll:StreamCategoryPreference!
    
    override func setUp() {
        super.setUp()
        catPrefEmpty = StreamCategoryPreference()
        catPrefAll = StreamCategoryPreference.all()
    }
    
    override func tearDown() {
        catPrefEmpty = nil
        catPrefAll = nil
        
        super.tearDown()
    }
    
    func testHasType() {
        XCTAssertTrue(catPrefAll.hasType(.Gaming))
    }
    
    func testAddType() {
        catPrefEmpty.addType(.News)
        XCTAssertTrue(catPrefEmpty.hasType(.News))
    }
    
    func testRemoveType() {
        catPrefAll.removeType(.People)
        XCTAssertFalse(catPrefAll.hasType(.People))
    }
    
    func testSetTypes() {
        catPrefEmpty.setTypes([.Entertainment])
        
        XCTAssertTrue(catPrefEmpty.hasType(.Entertainment))
        XCTAssertFalse(catPrefEmpty.hasType(.Gaming))
        XCTAssertFalse(catPrefEmpty.hasType(.People))
        XCTAssertFalse(catPrefEmpty.hasType(.News))
        XCTAssertFalse(catPrefEmpty.hasType(.Sports))
        XCTAssertFalse(catPrefEmpty.hasType(.Misc))
    }
}
