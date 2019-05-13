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

    // The System Under Test - a Question.
    var sut: Question!

    override func setUp() {
        super.setUp()
        sut = Question()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testQuestionDateCanBeSet() {
        let date = Date.distantPast
        sut.date = date
        XCTAssertEqual(sut.date, date, "A Question shall allow its date to be set.")
    }

    func testDefaultDateIsCurrentDate() {
        let now = Date()
        let question = Question()
        let later = Date()
        let range = now...later
        XCTAssertTrue(range.contains(question.date), "A Question shall have a default date that is the current date.")
    }

    func testQuestionHasAScore() {
        let score = 0
        XCTAssertEqual(sut.score, score, "A Question shall have a default score of zero.")
    }

    func testQuerstionScoreCanBeSet() {
        let score = 42
        sut.score = 42
        XCTAssertEqual(sut.score, score, "A Questions shall allow it's score to be set.")
    }

    func testQuestionHasATitle() {
        let title = ""
        XCTAssertEqual(sut.title, title, "A Questions shall have a title with a default value of an empty string.")
    }

    func testQuestionsTitleCanBeSet() {
        let title = "Do iPhones also dream of electric sheep?"
        sut.title = title
        XCTAssertEqual(sut.title, title, "A Questions shall allow it's title to be set.")
    }
}
