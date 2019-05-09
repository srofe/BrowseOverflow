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

    override func setUp() {
    }

    override func tearDown() {
    }

    func testTopicCanBeCreated() {
        let topic = Topic()
        XCTAssertNotNil(topic, "A Topic shall be able to be created.")
    }

}
