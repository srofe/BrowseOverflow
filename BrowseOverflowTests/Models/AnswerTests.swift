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
    let answerPerson = Person(name: "Simon Rofe", avatarUrl: URL(string: "http://example.com/avatar.png")!)
    let answerDefaultScore = 0
    let answerScore = 42

    var otherAnswer: Answer!

    override func setUp() {
        super.setUp()
        sut = Answer()
        otherAnswer = Answer()
        otherAnswer.text = "I have the answer you need"
    }

    override func tearDown() {
        sut = nil
        otherAnswer = nil
        super.tearDown()
    }

    func testAnswerHasSomeText() {
        sut.text = answerText
        XCTAssertEqual(sut.text, answerText, "An Answer has some text.")
    }

    func testSomeoneProvidedTheAnswer() {
        sut.person = answerPerson
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

    func testUnacceptedAnswerIsLessThanAcceptedAnswer() {
        otherAnswer.accepted = true
        XCTAssertTrue(sut < otherAnswer, "The unaccepted answer shall be less than the accepted answer.")
        XCTAssertFalse(otherAnswer < sut, "The unaccepted answer shall be less than the accepted answer.")
    }

    func testAnswerWithLowerScoreIsLessThanGreaterScore() {
        sut.score = answerScore
        otherAnswer.score = answerScore + 10
        XCTAssertTrue(sut < otherAnswer, "The answer with the lower score shall be less than the answer with the greater score.")
        XCTAssertFalse(otherAnswer < sut, "The answer with the lower score shall be less than the answer with the greater score.")
    }

    func testAnswersWithSameScoresNotLessThan() {
        sut.score = answerScore
        otherAnswer.score = answerScore
        XCTAssertFalse(sut < otherAnswer, "Answers with the same score shall not be less than.")
        XCTAssertFalse(otherAnswer < sut, "Answers with the same score shall not be less than.")

    }

    func testAcceptedAnswerIsGreaterThanUnacceptedAnswer() {
        sut.accepted = true
        XCTAssertTrue(sut > otherAnswer, "The accepted answer shall be greater than the unaccepted answer.")
        XCTAssertFalse(otherAnswer > sut, "The accepted answer shall be greater than the unaccepted answer.")
    }

    func testAnswerWithHigherScoreIsGreaterThanLowerScore() {
        sut.score = answerScore + 10
        otherAnswer.score = answerScore
        XCTAssertTrue(sut > otherAnswer, "The answer with the higher score shall be greater than the answer with the lower score.")
        XCTAssertFalse(otherAnswer > sut, "The answer with the higher score shall be greater than the answer with the lower score.")
    }

    func testAnswersWithSameScoresNotGreaterThan() {
        sut.score = answerScore
        otherAnswer.score = answerScore
        XCTAssertFalse(sut > otherAnswer, "Answers with the same score shall not be greater than.")
        XCTAssertFalse(otherAnswer > sut, "Answers with the same score shall not be greater than.")
    }

    func testAnswersWithSameTextAreEqual() {
        sut.text = answerText
        otherAnswer.text = answerText
        XCTAssertEqual(sut, otherAnswer, "Two Answers with the same text shall be equal.")
    }

    func testAnswersWithDifferntTextShallNotBeEqual() {
        sut.text = answerText
        XCTAssertNotEqual(sut, otherAnswer, "Two Answers with different text shall not be equal.")
    }

    func testAnswersWithSamePersonAndTextShallBeEqual() {
        sut.text = answerText
        otherAnswer.text = answerText
        sut.person = answerPerson
        otherAnswer.person = answerPerson
        XCTAssertEqual(sut, otherAnswer, "Two Answers with the same text and person shall be equal.")
    }

    func testAnswersWithDifferentPersonShallNotBeEqual() {
        sut.text = answerText
        otherAnswer.text = answerText
        sut.person = answerPerson
        XCTAssertNotEqual(sut, otherAnswer, "Two Answers with the different person shall not be equal.")
    }

    func testAnswersWithSameAcceptedPersonAndTextShallBeEqual() {
        sut.text = answerText
        otherAnswer.text = answerText
        sut.person = answerPerson
        otherAnswer.person = answerPerson
        sut.accepted = true
        otherAnswer.accepted = true
        XCTAssertEqual(sut, otherAnswer, "Two Answers with the same text, person and accepted shall be equal.")
        sut.accepted = false
        otherAnswer.accepted = false
        XCTAssertEqual(sut, otherAnswer, "Two Answers with the same text, person and accepted shall be equal.")
    }

    func testAnswersWithDifferentAcceptedShallNotBeEqual() {
        sut.text = answerText
        otherAnswer.text = answerText
        sut.person = answerPerson
        otherAnswer.person = answerPerson
        sut.accepted = true
        otherAnswer.accepted = false
        XCTAssertNotEqual(sut, otherAnswer, "Two Answers with different accepted shall not be equal.")
    }

    func testAnswersWithSamePropertiesShallBeEqual() {
        sut.text = answerText
        otherAnswer.text = answerText
        sut.person = answerPerson
        otherAnswer.person = answerPerson
        sut.accepted = true
        otherAnswer.accepted = true
        sut.score = answerScore
        otherAnswer.score = answerScore
        XCTAssertEqual(sut, otherAnswer, "Two Answers with the same properties shall be equal.")
    }

    func testAnswersWithDifferentScoreShallNotBeEqual() {
        sut.text = answerText
        otherAnswer.text = answerText
        sut.person = answerPerson
        otherAnswer.person = answerPerson
        sut.accepted = true
        otherAnswer.accepted = true
        sut.score = answerScore
        otherAnswer.score = answerScore + 10
        XCTAssertNotEqual(sut, otherAnswer, "Two Answers with different scores shall not be equal.")
    }
}
