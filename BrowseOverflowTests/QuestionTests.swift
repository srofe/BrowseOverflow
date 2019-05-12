//
//  QuestionTests.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 10/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import BrowseOverflow

class QuestionTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testQuestionDateCanBeSet() {
        let date = Date.distantPast
        var question = Question()
        question.date = date
        XCTAssertEqual(question.date, date, "A Question shall allow its date to be set.")
    }
}
