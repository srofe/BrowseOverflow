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

    var sutUnderlyingError: NSError!

    override func setUp() {
        super.setUp()
        sut = StackOverflowManager()
        sut.delegate = MockStackOverflowManagerDelegate()
        sut.communicator = MockStackOverflowCommunicator()
        sutUnderlyingError = NSError(domain: "Test domain", code: 0, userInfo: nil)
    }

    override func tearDown() {
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
        XCTAssertNotEqual(sutUnderlyingError, (sut.delegate as? MockStackOverflowManagerDelegate)?.error, "A delegate error shall be at the correct level of abstration.")
    }

    func testErrorReturnedToDelegateDocumentsUnderlyingError() {
        sut.searchingForQuestionsFailed(with: sutUnderlyingError)
        let delegateError = (sut.delegate as? MockStackOverflowManagerDelegate)?.error
        let delegateUndelyingError = delegateError?.userInfo[NSUnderlyingErrorKey]
        XCTAssertEqual((delegateUndelyingError as? NSError), sutUnderlyingError, "The underlying error shall be available to client code.")
    }

    func testQuestionJsonParssedTpQuestionBuilder() {
        let builder = FakeQuestionBuilder()
        sut.questionBuilder = builder
        sut.received(questions: "Fake JSON")
        let fakeJsonFromBuilder = (sut.questionBuilder as? FakeQuestionBuilder)?.json
        XCTAssertEqual(fakeJsonFromBuilder, "Fake JSON", "The downloaded JSON shall be sent to the builder.")
    }
}

class MockStackOverflowManagerDelegate : StackOverflowManagerDelegate {
    var error: NSError? = nil

    func fetchingQuestionsFailed(error: NSError) {
        self.error = error
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

    func questionsFrom(json: String) -> [Question] {
        self.json = json
        return []
    }
}
