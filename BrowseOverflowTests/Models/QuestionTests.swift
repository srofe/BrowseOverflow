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

    func testQuestionHasAnId() {
        XCTAssertEqual(sut.id, -1, "A Question shall have an ID with a default value of -1.")
    }

    func testQuestionIdCanBeSet() {
        sut.id = 794054
        XCTAssertEqual(sut.id, 794054, "A Question shall allow it's ID to be set.")
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

    func testQuestionHasABody() {
        XCTAssertNil(sut.body, "A Question shall have a body with a default value of nil.")
    }

    func testQuestionDefaultAnswersIsEmpty() {
        XCTAssertEqual(sut.answers.count, 0, "The default number of Answers in a question shall be 0.")
    }

    func testQuestionHasAnAsker() {
        let asker = Person(name: "Joe Bloggs", avatarUrl: URL(string: "http://example.com/avatar.png")!)
        sut.asker = asker
        XCTAssertEqual(sut.asker, asker, "A Question shall have a Person who asked the questin.")
    }

    func testDefaultAskerIsNil() {
        XCTAssertNil(sut.asker, "The default asker for a Question shall be nil.")
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

    func testQuestionsWithTheSameScoreAreTheSame() {
        sut.date = Date.distantFuture
        sut.score = 9
        sutOtherQuestion.date = Date.distantFuture
        sutOtherQuestion.score = 9
        XCTAssertEqual(sut, sutOtherQuestion, "Two Questions with the same score shall be equal.")
    }

    func testQuestionsWithDifferentDatesAreDifferent() {
        sut.date = Date.distantFuture
        sutOtherQuestion.date = Date.distantFuture
        XCTAssertEqual(sut, sutOtherQuestion, "Before setting different scores, Questions must be equal.")
        sut.score = 9
        sutOtherQuestion.score = 8
        XCTAssertNotEqual(sut, sutOtherQuestion, "Two Questions with different scores shall not be equal.")
    }

    func testQuestionsWithTheSameTitleAreEqual() {
        sut.date = Date.distantFuture
        sutOtherQuestion.date = Date.distantFuture
        sut.title = "Question title"
        sutOtherQuestion.title = "Question title"
        XCTAssertEqual(sut, sutOtherQuestion, "Two Questions with the same title shall be equal.")
    }

    func testQuestionsWithDifferentTitlesAreNotEqual() {
        sut.date = Date.distantFuture
        sutOtherQuestion.date = Date.distantFuture
        XCTAssertEqual(sut, sutOtherQuestion, "Before setting different titles, Questions must be equal.")
        sut.title = "Question title"
        sutOtherQuestion.title = "Other title"
        XCTAssertNotEqual(sut, sutOtherQuestion, "Two Questions with the same title shall be equal.")

    }

    func testQuestionsWithTheSameAnswerArrayAreEqual() {
        sut.date = Date.distantFuture
        sutOtherQuestion.date = Date.distantFuture
        let answerOne = Answer()
        let answerTwo = Answer()
        sut.add(answer: answerOne)
        sut.add(answer: answerTwo)
        sutOtherQuestion.add(answer: answerOne)
        sutOtherQuestion.add(answer: answerTwo)
        XCTAssertEqual(sut, sutOtherQuestion, "Two Questions with the same answers shall be the same.")
    }

    func testQuestionsWithDifferentAnswerArrayAreNotEqual() {
        sut.date = Date.distantFuture
        sutOtherQuestion.date = Date.distantFuture
        XCTAssertEqual(sut, sutOtherQuestion, "Before setting different answers, Questions must be equal.")
        let answerOne = Answer()
        var answerTwo = Answer()
        answerTwo.text = "Answer Two"
        var answerThree = Answer()
        answerThree.text = "Answer Three"
        sut.add(answer: answerOne)
        sut.add(answer: answerTwo)
        sutOtherQuestion.add(answer: answerOne)
        sutOtherQuestion.add(answer: answerThree)
        XCTAssertNotEqual(sut, sutOtherQuestion, "Two Questions with different answers shall not be the same.")
    }
}
