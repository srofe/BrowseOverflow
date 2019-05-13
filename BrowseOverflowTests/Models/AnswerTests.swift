//
//  AnswerTests.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 13/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import BrowseOverflow

class AnswerTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testAnswerHasSomeText() {
        var answer = Answer()
        answer.text = "The answer is 42"
        XCTAssertEqual(answer.text, "The answer is 42", "An Answer has some text.")
    }
}
