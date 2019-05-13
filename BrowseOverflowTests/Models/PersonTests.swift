//
//  PersonTests.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 13/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import BrowseOverflow

class PersonTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testPersonHasAName() {
        let person = Person(name: "Simon Rofe")
        XCTAssertEqual(person.name, "Simon Rofe", "A Person shall have a name.")
    }

}
