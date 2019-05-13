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

    // The System Under Test - A Person
    var sut: Person!

    let personName = "Simon Rofe"
    let personUrl = URL(string: "http://example.com/avatar.png")

    override func setUp() {
        super.setUp()
        sut = Person(name: personName, avatarUrl: personUrl!)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testPersonHasAName() {
        XCTAssertEqual(sut.name, personName, "A Person shall have a name.")
    }

    func testPersonHasAvaratURL() {
        XCTAssertEqual(sut.avatarUrl, personUrl!, "A Person shall have an avatar URL.")
    }
}
