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

    var sutOtherQuestion: Question!

    override func setUp() {
        super.setUp()
        sut = Question()
        sutOtherQuestion = Question()
    }

    override func tearDown() {
        sutOtherQuestion = nil
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

    func testQuestionDefaultAnswersIsEmpty() {
        XCTAssertEqual(sut.answers.count, 0, "The default number of Answers in a question shall be 0.")
    }

    func testQuestionCanAddAnswers() {
        let answer = Answer()
        sut.add(answer: answer)
        XCTAssertEqual(sut.answers.count, 1, "A Questions shall allow answers to be added.")
    }

    func testQuesionHasAcceptedAnswerFirst() {
        var acceptedAnswer = Answer()
        acceptedAnswer.accepted = true
        var lowScoreAnswer = Answer()
        lowScoreAnswer.score = -4
        var highScoreAnswer = Answer()
        highScoreAnswer.score = 4
        sut.add(answer: lowScoreAnswer)
        sut.add(answer: highScoreAnswer)
        sut.add(answer: acceptedAnswer)
        XCTAssertTrue(sut.answers[0].accepted, "The accepted answer shall be the first answer.")
    }

    func testQuesionHasHighScoreAnswerBeforeLowScoreAnswer() {
        var acceptedAnswer = Answer()
        acceptedAnswer.accepted = true
        var lowScoreAnswer = Answer()
        lowScoreAnswer.score = -4
        var highScoreAnswer = Answer()
        highScoreAnswer.score = 4
        sut.add(answer: lowScoreAnswer)
        sut.add(answer: highScoreAnswer)
        sut.add(answer: acceptedAnswer)
        let lowIndex = sut.answers.firstIndex(of: lowScoreAnswer)!
        let highIndex = sut.answers.firstIndex(of: highScoreAnswer)!
        XCTAssertTrue(highIndex < lowIndex, "The higher scoring answer shall shall come before the low scoring answer.")
    }

    func testQuestionsWithSameDateAreEqual() {
        sut.date = Date.distantPast
        sutOtherQuestion.date = Date.distantPast
        XCTAssertEqual(sut, sutOtherQuestion, "Two Questions with the same date shall be equal.")
    }

    func testQuestionsWithDifferentDatesShallNotBeEquall() {
        sut.date = Date.distantPast
        sutOtherQuestion.date = Date.distantFuture
        XCTAssertNotEqual(sut, sutOtherQuestion, "Two Questions with different dates shall not be equal.")
    }
}
