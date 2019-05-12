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

    func testQuestionHasADate() {
        let date = Date()
        let question = Question(date: date)
        XCTAssertEqual(question.date, date, "A Question shall have a date.")
    }
}
