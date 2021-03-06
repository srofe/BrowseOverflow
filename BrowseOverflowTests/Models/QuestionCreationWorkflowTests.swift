//
//  QuestionCreationTests.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 16/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import BrowseOverflow

class QuestionCreationWorkflowTests: XCTestCase {

    // The System Under Test - a StackOverFlowManager
    var sut: StackOverflowManager!

    let sutJsonString = "Fake JSON"
    var sutUnderlyingError: Error!
    var sutFakeQuestionBuilder: FakeQuestionBuilder!
    var sutFakeAnswerBuilder: FakeAnswerBuilder!
    var sutQuestionArray: [Question]!
    var sutQuestion: Question!

    override func setUp() {
        super.setUp()
        sut = StackOverflowManager()
        sut.delegate = MockStackOverflowManagerDelegate()
        sut.communicator = MockStackOverflowCommunicator()
        sutFakeQuestionBuilder = FakeQuestionBuilder()
        sutFakeAnswerBuilder = FakeAnswerBuilder()
        sutQuestionArray = [Question()]
        sutFakeQuestionBuilder.arrayToReturn = sutQuestionArray
        sut.questionBuilder = sutFakeQuestionBuilder
        sut.answerBuilder = sutFakeAnswerBuilder
        sutUnderlyingError = TestError.test
        sutQuestion = Question()
        sutQuestion.title = "A question to ask."
    }

    override func tearDown() {
        sutQuestion = nil
        sutQuestionArray = nil
        sutFakeAnswerBuilder = nil
        sutFakeQuestionBuilder = nil
        sutUnderlyingError = nil
        sut = nil
        super.tearDown()
    }

    func testWeHaveADelegate() {
        XCTAssertNotNil(sut.delegate, "The StackOverflowManager shall be able to assign a delegate.")
    }

    func testWeHaveACommunicator() {
        XCTAssertNotNil(sut.communicator, "The StackOverflowManager shall be able to assign a communicator.")
    }

    func testAskingForQuestionsMeansRequestingData() {
        let topic = Topic(name: "iPhone", tag: "iphone")
        sut.fetchQuestions(on: topic)
        XCTAssertTrue((sut.communicator as? MockStackOverflowCommunicator)!.wasAskedToFetchQuestions, "The communicator shall be asked to fetch data when request with a topic.")
    }

    func testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator() {
        sut.searchingForQuestionsFailed(with: sutUnderlyingError)
        let delegateError = sut.delegate?.error
        XCTAssertTrue(delegateError is StackOverflowError, "The delegate error shall be at the correct level of abstration.")
    }

    func testErrorReturnedToDelegateDocumentsUnderlyingError() {
        sut.searchingForQuestionsFailed(with: sutUnderlyingError)
        let delegateError = sut.delegate?.error as? StackOverflowError
        let underlyingError = delegateError?.underlyingError
        XCTAssertTrue(underlyingError is TestError)
    }

    func testQuestionJsonParssedTpQuestionBuilder() {
        sut.received(questionsJson: sutJsonString)
        let fakeJsonFromBuilder = (sut.questionBuilder as? FakeQuestionBuilder)?.json
        XCTAssertEqual(fakeJsonFromBuilder, sutJsonString, "The downloaded JSON shall be sent to the builder.")
    }

    func testDelegateNotifiedOfErrorWhenQuestionBuilderFails() {
        sutFakeQuestionBuilder.errorToSet = sutUnderlyingError
        sut.questionBuilder = sutFakeQuestionBuilder
        sut.received(questionsJson: sutJsonString)
        let delegateError = sut.delegate?.error as? StackOverflowError
        let underlyingError = delegateError?.underlyingError
        XCTAssertNotNil(underlyingError, "The delegate shall have found out about an error when the builder returns nil.")
    }

    func testUnderlyingErrorCanBeNilIfQuestionsIsNil() {
        sut.received(questionsJson: sutJsonString)
        let delegateError = sut.delegate?.error as? StackOverflowError
        let underlyingError = delegateError?.underlyingError
        XCTAssertNil(underlyingError, "The delegate can receive an error with no underlying error.")
    }

    func testDelegateNotToldAboutErrorWhenQuestionsReceived() {
        sut.received(questionsJson: sutJsonString)
        let delegateError = sut.delegate?.error as? StackOverflowError
        XCTAssertNil(delegateError, "The delegate shall not receive en error when questions are returned.")
    }

    func testDelegateReceivesTheQuestionsDiscoveredByManager() {
        sut.received(questionsJson: sutJsonString)
        XCTAssertEqual(sut.delegate?.questions, sutQuestionArray, "The Manager shall send its questions to the delegate.")
    }

    func testEmptyArrayCanBePassedToDelegate() {
        sutFakeQuestionBuilder.arrayToReturn = []
        sut.questionBuilder = sutFakeQuestionBuilder
        sut.received(questionsJson: sutJsonString)
        XCTAssertEqual(sut.delegate?.questions, [], "Providing an empty array to the delegate shall not be an error.")
    }

    func testAskingForQuestionsBodyMeansRequestingData() {
        sut.fetchBody(for: sutQuestion)
        XCTAssertTrue((sut.communicator as? MockStackOverflowCommunicator)!.wasAskedToFetchBody, "The communicator shall be asked to fetch the body of a question.")
    }

    func testDelegateNotifiedOfFailureToFetchQuestion() {
        sut.fetchingQuestionFailed(with: sutUnderlyingError)
        let delegateError = sut.delegate?.error as? StackOverflowError
        let underlyingError = delegateError?.underlyingError
        XCTAssertEqual(delegateError?.kind, .questionBodyFetch, "The error reported when fetching a question body shall be a questionBodyFetch error.")
        XCTAssertNotNil(underlyingError, "The delegate shall be notified of any error when fetching a Question body.")
    }

    func testManagerPassesRetrievedQuestionBodyToQuestionBuilder() {
        sut.fetchBody(for: sutQuestion)
        sut.received(questionBodyJson: "Fake JSON")
        XCTAssertEqual((sut.questionBuilder as? FakeQuestionBuilder)?.json, "Fake JSON", "The Manager shall pass the question body JSON string to the QuestionBuilder.")
    }

    func testManagerPassesQuestionItWasSentToQuestionBuilder() {
        sut.fetchBody(for: sutQuestion)
        sut.received(questionBodyJson: "Fake JSON")
        XCTAssertEqual((sut.questionBuilder as? FakeQuestionBuilder)?.questionToFill, sutQuestion, "The Manager shall bass the question to be filled to the QuestionBuilder.")
    }

    func testManagerSetsQuestionNeedingBodyToNilWhenBodyReceived() {
        sut.fetchBody(for: sutQuestion)
        sut.received(questionBodyJson: "Fake JSON")
        XCTAssertNil(sut.questionNeedingBody, "The question needing a body shall be set to nil once the body has been received.")
    }

    func testAskingForAnswerMenansRequestionData() {
        sut.fetchAnswers(for: sutQuestion)
        XCTAssertTrue((sut.communicator as? MockStackOverflowCommunicator)!.wasAskedToFetchAnswers, "The communicator shall be asked to fetch answers to a question.")
    }

    func testDelegateNotifiedOfFailureToFetchAnswers() {
        sut.fetchingAnswersFailed(with: sutUnderlyingError)
        let delegateError = sut.delegate?.error as? StackOverflowError
        let underlyingError = delegateError?.underlyingError
        XCTAssertEqual(delegateError?.kind, .answersFetch, "The error reported when fetching answer shall be an answersFetch error.")
        XCTAssertNotNil(underlyingError, "The delegate shall be notified of any error when fetching answers to a Question.")
    }

    func testManagerPassesRetrievedAnswersToAnswerBuilder() {
        sut.fetchAnswers(for: sutQuestion)
        sut.received(answerJson: "Fake JSON")
        XCTAssertEqual((sut.answerBuilder as? FakeAnswerBuilder)?.json, "Fake JSON", "The manager shall pass the answer JSON string to the AnswerBuilder.")
    }

    func testDelegateNotifiedOfErrorWhenAnswerBuilderFails() {
        sutFakeAnswerBuilder.errorToSet = sutUnderlyingError
        sut.answerBuilder = sutFakeAnswerBuilder
        sut.fetchAnswers(for: sutQuestion)
        sut.received(answerJson: "Fake JSON")
        let delegateError = sut.delegate?.error as? StackOverflowError
        let underlyingError = delegateError?.underlyingError
        XCTAssertNotNil(underlyingError, "The delegate shall have found out about an error when the builder returns nil.")
    }
}

enum TestError: Error {
    case test
}

class MockStackOverflowManagerDelegate : StackOverflowManagerDelegate {
    var error: Error?
    var questions: [Question]? = nil

    func fetchingQuestionsFailed(error: Error) {
        self.error = error
    }

    func didReceiveQuestions(questions: [Question]) {
        self.questions = questions
    }
}

class MockStackOverflowCommunicator : StackOverflowCommunicator {
    var wasAskedToFetchQuestions = false
    var wasAskedToFetchBody = false
    var wasAskedToFetchAnswers = false
    override func searchForQuestions(with tag: String) {
        wasAskedToFetchQuestions = true
    }
    override func downloadInformationForQuestion(with id: Int) {
        wasAskedToFetchBody = true
    }
    override func downloadAnswersToQuestion(with id: Int) {
        wasAskedToFetchAnswers = true
    }
}

class FakeQuestionBuilder : QuestionBuilderProtocol {
    var json: String = ""
    var arrayToReturn: [Question]? = nil
    var errorToSet: Error? = nil
    var questionToFill: Question? = nil

    func questions(from json: String) throws -> [Question]? {
        if let error = errorToSet {
            throw error
        }
        self.json = json
        return arrayToReturn
    }

    func questionBody(for question: inout Question, from json: String) {
        self.questionToFill = question
        self.json = json
    }
}

class FakeAnswerBuilder : AnswerBuilderProtocol {
    var json = ""
    var errorToSet: Error? = nil

    func addAnswer(to question: inout Question, containing json: String) throws {
        if let error = errorToSet {
            throw error
        }
        self.json = json
    }
}
