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

    // The System Under Test - an Answer
    var sut: Answer!

    let answerText = "The answer is 42"
    let answerDefaultScore = 0
    let answerScore = 42

    var otherAnswer = Answer()

    override func setUp() {
        super.setUp()
        sut = Answer()
        otherAnswer.text = "I have the answer you need"
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testAnswerHasSomeText() {
        sut.text = answerText
        XCTAssertEqual(sut.text, answerText, "An Answer has some text.")
    }

    func testSomeoneProvidedTheAnswer() {
        let person = Person(name: "Simon Rofe", avatarUrl: URL(string: "http://example.com/avatar.png")!)
        sut.person = person
        XCTAssertNotNil(sut.person, "An Answer shall have someone who provided it.")
    }

    func testAnswerIsNotAcceptedByDefault() {
        XCTAssertFalse(sut.accepted, "An Answer is not accepted by default.")
    }

    func testAnswerCanBeAccepted() {
        sut.accepted = true
        XCTAssertTrue(sut.accepted, "An Answer shall be able to be accepted.")
    }

    func testAnswerHasAScoreWithDefaultOfZero() {
        XCTAssertEqual(sut.score, answerDefaultScore, "An Answer shall have a score with a default of zero.")
    }

    func testScoreCanBeSet() {
        sut.score = answerScore
        XCTAssertEqual(sut.score, answerScore, "An Answer shall allow the score to be set.")
    }

    func testAcceptedAnswerComesBeforeUnaccepted() {
        otherAnswer.accepted = true
        XCTAssertEqual(sut.compare(with: otherAnswer), .orderedDescending, "The accepted answer should come first.")
        XCTAssertEqual(otherAnswer.compare(with: sut), .orderedAscending, "The accepted answer should come first.")
    }
}
