//
//  QuestionCreationTests.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 16/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import BrowseOverflow

class QuestionCreationTests: XCTestCase {

    // The System Under Test - a StackOverFlowManager
    var sut: StackOverflowManager!

    let sutJsonString = "Fake JSON"
    var sutUnderlyingError: Error!
    var sutFakeQuestionBuilder: FakeQuestionBuilder!
    var sutQuestionArray: [Question]!

    override func setUp() {
        super.setUp()
        sut = StackOverflowManager()
        sut.delegate = MockStackOverflowManagerDelegate()
        sut.communicator = MockStackOverflowCommunicator()
        sutUnderlyingError = TestError.test
        sutFakeQuestionBuilder = FakeQuestionBuilder()
        sutQuestionArray = [Question(date: Date(), score: 0, title: "Question Title", answers: [])]
    }

    override func tearDown() {
        sutQuestionArray = nil
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
        sut.questionBuilder = sutFakeQuestionBuilder
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
        sut.questionBuilder = sutFakeQuestionBuilder
        sut.received(questionsJson: sutJsonString)
        let delegateError = sut.delegate?.error as? StackOverflowError
        let underlyingError = delegateError?.underlyingError
        XCTAssertNil(underlyingError, "The delegate can receive an error with no underlying error.")
    }

    func testDelegateNotToldAboutErrorWhenQuestionsReceived() {
        sutFakeQuestionBuilder.arrayToReturn = sutQuestionArray
        sut.questionBuilder = sutFakeQuestionBuilder
        sut.received(questionsJson: sutJsonString)
        let delegateError = sut.delegate?.error as? StackOverflowError
        XCTAssertNil(delegateError, "The delegate shall not receive en error when questions are returned.")
    }

    func testDelegateReceivesTheQuestionsDiscoveredByManager() {
        sutFakeQuestionBuilder.arrayToReturn = sutQuestionArray
        sut.questionBuilder = sutFakeQuestionBuilder
        sut.received(questionsJson: sutJsonString)
        XCTAssertEqual(sut.delegate?.questions, sutQuestionArray, "The Manager shall send its questions to the delegate.")
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
    func searchForQuestions(with tag: String) {
        wasAskedToFetchQuestions = true
    }
}

class FakeQuestionBuilder : QuestionBuilder {
    var json: String = ""
    var arrayToReturn: [Question]? = nil
    var errorToSet: Error? = nil

    func questionsFrom(json: String) throws -> [Question]? {
        if let error = errorToSet {
            throw error
        }
        self.json = json
        return arrayToReturn
    }
}
