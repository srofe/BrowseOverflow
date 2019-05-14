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

    func testTwoPersonsWithSameNameAndURLAreEqual() {
        let otherPerson = Person(name: personName, avatarUrl: personUrl!)
        XCTAssertEqual(sut, otherPerson, "Two Persons with the same name and URL shall be equal.")
    }

    func testPersonWithDifferentNameAreNotEqual() {
        let otherPerson = Person(name: "Joe Bloggs", avatarUrl: personUrl!)
        XCTAssertNotEqual(sut, otherPerson, "Person's with different name and same URL shall not be equal.")
    }

    func testPersonWithDifferentURLAreNotEqual() {
        let otherPerson = Person(name: personName, avatarUrl: URL(string: "http://example.com")!)
        XCTAssertNotEqual(sut, otherPerson, "Person's with different name and same URL shall not be equal.")
    }
}
