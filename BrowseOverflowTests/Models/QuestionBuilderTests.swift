//
//  QuestionBuilderTests.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 28/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import BrowseOverflow

class QuestionBuilderTests: XCTestCase {

    // The System Under Test - a QuestionBuilder
    var sut: QuestionBuilder!

    let sutNotJson = "Not JSON"
    let sutValidJson = "{ \"noquestions\": true }"

    override func setUp() {
        super.setUp()
        sut = QuestionBuilder()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testErrorThrownWhenStringIsInvalidJson() {
        XCTAssertThrowsError(try sut.questionsFrom(json: sutNotJson), "A QuestionBuilder shall raise an exception if passed an non-JSON string.") { error in
            XCTAssertEqual(error as? QuestionBuilderError, QuestionBuilderError.invalidJson, "A QuestionBuilder shall set the error type to invalid JSON if the JSON is not valid.")
        }
    }

    func testErrorThrownWhenJsonHasNoQuestions() {
        XCTAssertThrowsError(try sut.questionsFrom(json: sutValidJson), "A QuestionBuilder shall throw a QuestionsBuilder error if question data is missing.") { error in
            XCTAssertEqual(error as? QuestionBuilderError, QuestionBuilderError.missingData, "A QuestionBuilder shall set the error type to missing data if the JSON is valid and there is no question data.")
        }
    }
}
