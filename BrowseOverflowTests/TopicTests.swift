//
//  TopicTests.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 9/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import BrowseOverflow

class TopicTests: XCTestCase {

    // The System Under Test - a Topic.
    var sut: Topic!

    let sutTopicName = "iPhone"

    override func setUp() {
        super.setUp()
        sut = Topic(name: sutTopicName)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testTopicCanBeCreated() {
        XCTAssertNotNil(sut, "A Topic shall be able to be created.")
    }

    func testTopicCanBeNamed() {
        XCTAssertEqual(sut.name, sutTopicName, "A Topic shall have a name.")
    }
}
