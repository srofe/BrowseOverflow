//
//  StackOverflowCommunicatorTests.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 31/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import BrowseOverflow

class StackOverflowCommunicatorTests: XCTestCase {

    // The System Under Test - a StackOverflowCommunicator
    var sut: StackOverflowCommunicator!
    var errorSut: ErrorInsertingStackOverflowCommunicator!
    var dataSut: DataInsertingStackOverflowCommunicator!

    // Test constants.
    var sutDelegateUrlSession: URLSession!
    let sutHost = "api.stackexchange.com"
    let sutSearchPath = "/2.2/search"
    let sutQuestionPath = "/2.2/questions/12345"
    let sutAnswerPath = "/2.2/questions/12345/answers"
    let sutQueryTag = "ios"
    let sutQuestionId = 12345
    let sutErrorFourOhFour = 404
    let sutErrorNineOhNine = 999

    override func setUp() {
        super.setUp()

        sut = StackOverflowCommunicator()
        sut.session = MockURLSession()
        sut.dataTask = MockDataTask()

        let configuration = URLSessionConfiguration.default
        sutDelegateUrlSession = URLSession(configuration: configuration, delegate: sut, delegateQueue: nil)

        errorSut = ErrorInsertingStackOverflowCommunicator()
        errorSut.session = sutDelegateUrlSession
        errorSut.delegate = MockStackOverflowManager()

        dataSut = DataInsertingStackOverflowCommunicator()
        dataSut.delegate = MockStackOverflowManager()
        dataSut.session = sutDelegateUrlSession
    }

    override func tearDown() {
        sutDelegateUrlSession = nil
        dataSut = nil
        errorSut = nil
        sut = nil
        super.tearDown()
    }

    func testSearchingForQuestionsOnTopicCallsTopicApi() {
        sut.searchForQuestions(with: sutQueryTag)
        let urlElements = (sutHost, sutSearchPath, ["pagesize":"20","order":"desc","sort":"activity","tagged":"ios","site":"stackoverflow"])
        AssertEquivalent(url: (sut.session as! MockURLSession).fetchingUrl.first!, urlElements: urlElements, "A StackOverflowCommunicator shall build a URL for searching tags.")
    }

    func testSearchingForQuestionOnTopicWithSpacesIsValid() {
        sut.searchForQuestions(with: "unit testing")
        let urlElements = (sutHost, sutSearchPath, ["pagesize":"20","order":"desc","sort":"activity","site":"stackoverflow", "tagged":"unit testing"])
        AssertEquivalent(url: (sut.session as! MockURLSession).fetchingUrl.first!, urlElements: urlElements, "A StackOverflowCommunicator shall allow for search terms with spaces.")
    }

    func testFillingInQuestionBodyCallsQuestionAPI() {
        sut.downloadInformationForQuestion(with: sutQuestionId)
        let urlElements = (sutHost, sutQuestionPath, ["order":"desc","sort":"activity","site":"stackoverflow", "filter":"withBody"])
        AssertEquivalent(url: (sut.session as! MockURLSession).fetchingUrl.first!, urlElements: urlElements, "A StackOverflowCommunicator shall build a URL for downloading a question with an ID.")
    }

    func testTestAnswersToQuestionCallsQuestionApi() {
        sut.downloadAnswersToQuestion(with: sutQuestionId)
        let urlElements = (sutHost, sutAnswerPath, ["order":"desc","sort":"activity","site":"stackoverflow"])
        AssertEquivalent(url: (sut.session as! MockURLSession).fetchingUrl.first!, urlElements: urlElements, "A StackOverflowCommunicator shall build a URL for downloading a question with an ID.")
    }

    func testSearchingForQuestionsCallsDataTaskResume() {
        sut.searchForQuestions(with: sutQueryTag)
        XCTAssertTrue((sut.session as! MockURLSession).dataTask!.resumeCalled, "A StackOverflowCommunicator shall call the data task resume method")
    }

    func testMakingSecondRequestCancelsFirstRequest() {
        sut.searchForQuestions(with: sutQueryTag)
        let firstDataTask = (sut.session as! MockURLSession).dataTask
        sut.downloadInformationForQuestion(with: sutQuestionId)
        XCTAssertTrue(firstDataTask!.cancelCalled, "A StackOverflowCommunicator shall cancel a request if a second request is made.")
    }

    func testCompletingTaskCancelsTask() {
        sut.session = sutDelegateUrlSession
        // Capture data task befored it is set nil in sut.urlSession(_:task:didCompleteWithError)
        let dataTaskUsed = sut.dataTask
        sut.urlSession(sutDelegateUrlSession, task: sut.dataTask!, didCompleteWithError: nil)
        XCTAssertTrue((dataTaskUsed as! MockDataTask).cancelCalled, "A StackOverflowCommunicator shall cancel a request when it is completed.")
    }

    func testDataTaskIsSetToNilWhenSessionCompleted() {
        sut.session = sutDelegateUrlSession
        sut.urlSession(sutDelegateUrlSession, task: sut.dataTask!, didCompleteWithError: nil)
        XCTAssertNil(sut.dataTask, "A StackOverflowCommunicator shall set the data task to nil when it is completed.")
    }

    func testReceiving404ResponseToTopicSearchPassesErrorToDelegate() {
        errorSut.searchForQuestions(with: sutQueryTag)
        let manager = errorSut.delegate as? MockStackOverflowManager
        XCTAssertEqual(manager?.topicFailureErrorCode, sutErrorFourOhFour, "A StackOverflowCommunicator shall pass search errors to its delegate.")
    }

    func testReceiving404ResponseToQuestionBodyRequestPassesErrorToDelegate() {
        errorSut.downloadInformationForQuestion(with: sutQuestionId)
        let manager = errorSut.delegate as? MockStackOverflowManager
        XCTAssertEqual(manager?.bodyFailureErrorCode, sutErrorFourOhFour, "A StackOverflowCommunicator shall pass question body errors to its delegate.")
    }

    func testReceiving404ResponseToAnswerRequestPassesErrorToDelegate() {
        errorSut.downloadAnswersToQuestion(with: sutQuestionId)
        let manager = errorSut.delegate as? MockStackOverflowManager
        XCTAssertEqual(manager?.answerFailureErrorCode, sutErrorFourOhFour, "A StackOverflowCommunicator shall pass answer request errors to its delegate.")
    }

    func testSessionErrorToTopicSearchIsPassedToDelegate () {
        errorSut.sessionError = TestError.test
        errorSut.searchForQuestions(with: sutQueryTag)
        let manager = errorSut.delegate as? MockStackOverflowManager
        XCTAssertEqual(manager?.topicFailureErrorCode, sutErrorNineOhNine, "A StackOverflowCommunicator shall pass search session error to its delegate.")
    }

    func testSessionErrorToQuestionBodyRequesIsPassedToDelegate() {
        errorSut.sessionError = TestError.test
        errorSut.downloadInformationForQuestion(with: sutQuestionId)
        let manager = errorSut.delegate as? MockStackOverflowManager
        XCTAssertEqual(manager?.bodyFailureErrorCode, sutErrorNineOhNine, "A StackOverflowCommunicator shall pass question body session error to its delegate.")
    }

    func testSessionErrorToAnserRequesIsPassedToDelegate() {
        errorSut.sessionError = TestError.test
        errorSut.downloadAnswersToQuestion(with: sutQuestionId)
        let manager = errorSut.delegate as? MockStackOverflowManager
        XCTAssertEqual(manager?.answerFailureErrorCode, sutErrorNineOhNine, "A StackOverflowCommunicator shall pass answer request session error to its delegate.")
    }

    func testSuccessfulQuestionSearchPassesDataToDelegate() {
        let dataToSend = "Topic Search String".data(using: .utf8)!
        let dataTask = MockDataTask()
        dataSut.urlSession(dataSut.session as! URLSession, dataTask: dataTask, didReceive: dataToSend)
        dataSut.searchForQuestions(with: sutQueryTag)
        let manager = dataSut.delegate as? MockStackOverflowManager
        XCTAssertEqual(manager?.topicSearchString, "Topic Search String")
    }

    func testSuccessfulBodyFetchPassesDataToDelegate() {
        let dataToSend = "Topic Search String".data(using: .utf8)!
        let dataTask = MockDataTask()
        dataSut.urlSession(dataSut.session as! URLSession, dataTask: dataTask, didReceive: dataToSend)
        dataSut.downloadInformationForQuestion(with: sutQuestionId)
        let manager = dataSut.delegate as? MockStackOverflowManager
        XCTAssertEqual(manager?.bodySearchString, "Topic Search String")
    }

    func testSuccessfulAnswerFetchPassesDataToDelegate() {
        let dataToSend = "Answers to Question".data(using: .utf8)!
        let dataTask = MockDataTask()
        dataSut.urlSession(dataSut.session as! URLSession, dataTask: dataTask, didReceive: dataToSend)
        dataSut.downloadAnswersToQuestion(with: sutQuestionId)
        let manager = dataSut.delegate as? MockStackOverflowManager
        XCTAssertEqual(manager?.answerSearchString, "Answers to Question")
    }

    func testAdditionalDataAppendedToDownload() {
        var dataToSend = "Answers to Question".data(using: .utf8)!
        let dataTask = MockDataTask()
        dataSut.urlSession(dataSut.session as! URLSession, dataTask: dataTask, didReceive: dataToSend)
        dataToSend = ", which you have asked.".data(using: .utf8)!
        dataSut.urlSession(dataSut.session as! URLSession, dataTask: dataTask, didReceive: dataToSend)
        dataSut.downloadAnswersToQuestion(with: sutQuestionId)
        let manager = dataSut.delegate as? MockStackOverflowManager
        XCTAssertEqual(manager?.answerSearchString, "Answers to Question, which you have asked.")
    }
}
