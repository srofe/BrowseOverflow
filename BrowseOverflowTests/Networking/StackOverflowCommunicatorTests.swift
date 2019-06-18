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

    // Test constants.
    var sutDelegateUrlSession: URLSession!
    var sutMockUrlSession: MockURLSession!
    let sutHost = "api.stackexchange.com"
    let sutSearchPath = "/2.2/search"
    let sutQuestionPath = "/2.2/questions/12345"
    let sutAnswerPath = "/2.2/questions/12345/answers"
    let sutQueryTag = "ios"
    let sutQuestionId = 12345

    override func setUp() {
        super.setUp()
        sut = StackOverflowCommunicator()
        let configuration = URLSessionConfiguration.default
        sutDelegateUrlSession = URLSession(configuration: configuration, delegate: sut, delegateQueue: nil)
        sutMockUrlSession = MockURLSession()
    }

    override func tearDown() {
        sutMockUrlSession = nil
        sutDelegateUrlSession = nil
        sut = nil
        super.tearDown()
    }

    func testSearchingForQuestionsOnTopicCallsTopicApi() {
        sut.session = sutMockUrlSession
        sut.searchForQuestions(with: sutQueryTag)
        let urlElements = (sutHost, sutSearchPath, ["pagesize":"20","order":"desc","sort":"activity","tagged":"ios","site":"stackoverflow"])
        AssertEquivalent(url: sutMockUrlSession.fetchingUrl.first!, urlElements: urlElements, "A StackOverflowCommunicator shall build a URL for searching tags.")
    }

    func testSearchingForQuestionOnTopicWithSpacesIsValid() {
        sut.session = sutMockUrlSession
        sut.searchForQuestions(with: "unit testing")
        let urlElements = (sutHost, sutSearchPath, ["pagesize":"20","order":"desc","sort":"activity","site":"stackoverflow", "tagged":"unit testing"])
        AssertEquivalent(url: sutMockUrlSession.fetchingUrl.first!, urlElements: urlElements, "A StackOverflowCommunicator shall allow for search terms with spaces.")
    }

    func testFillingInQuestionBodyCallsQuestionAPI() {
        sut.session = sutMockUrlSession
        sut.downloadInformationForQuestion(with: sutQuestionId)
        let urlElements = (sutHost, sutQuestionPath, ["order":"desc","sort":"activity","site":"stackoverflow", "filter":"withBody"])
        AssertEquivalent(url: sutMockUrlSession.fetchingUrl.first!, urlElements: urlElements, "A StackOverflowCommunicator shall build a URL for downloading a question with an ID.")
    }

    func testTestAnswersToQuestionCallsQuestionApi() {
        sut.session = sutMockUrlSession
        sut.downloadAnswersToQuestion(with: sutQuestionId)
        let urlElements = (sutHost, sutAnswerPath, ["order":"desc","sort":"activity","site":"stackoverflow"])
        AssertEquivalent(url: sutMockUrlSession.fetchingUrl.first!, urlElements: urlElements, "A StackOverflowCommunicator shall build a URL for downloading a question with an ID.")
    }

    func testSearchingForQuestionsCallsDataTaskResume() {
        sut.session = sutMockUrlSession
        sut.searchForQuestions(with: sutQueryTag)
        XCTAssertTrue(sutMockUrlSession.dataTask!.resumeCalled, "A StackOverflowCommunicator shall call the data task resume method")
    }

    func testMakingSecondRequestCancelsFirstRequest() {
        sut.session = sutMockUrlSession
        sut.searchForQuestions(with: sutQueryTag)
        let firstDataTask = sutMockUrlSession.dataTask
        sut.downloadInformationForQuestion(with: sutQuestionId)
        XCTAssertTrue(firstDataTask!.cancelCalled, "A StackOverflowCommunicator shall cancel a request if a second request is made.")
    }

    func testCompletingTaskCancelsTask() {
        sut.session = sutDelegateUrlSession
        let dataTask = MockDataTask()
        sut.dataTask = dataTask
        sut.urlSession(sutDelegateUrlSession, task: dataTask, didCompleteWithError: nil)
        XCTAssertTrue(dataTask.cancelCalled, "A StackOverflowCommunicator shall cancel a request when it is completed.")
    }

    func testDataTaskIsSetToNilWhenSessionCompleted() {
        sut.session = sutDelegateUrlSession
        sut.dataTask = MockDataTask()
        sut.urlSession(sutDelegateUrlSession, task: sut.dataTask!, didCompleteWithError: nil)
        XCTAssertNil(sut.dataTask, "A StackOverflowCommunicator shall set the data task to nil when it is completed.")
    }

    func testReceiving404ResponseToTopicSearchPassesErrorToDelegate() {
        let communicator = IntrospectionStackOverflowCommunicator()
        communicator.session = sutDelegateUrlSession
        communicator.delegate = MockStackOverflowManager()
        communicator.searchForQuestions(with: sutQueryTag)
        let manager = communicator.delegate as? MockStackOverflowManager
        XCTAssertEqual(manager?.topicFailureErrorCode, 404)
    }

    func testReceiving404ResponseToQuestionBodyRequestPassesErrorToDelegate() {
        let communicator = IntrospectionStackOverflowCommunicator()
        communicator.session = sutDelegateUrlSession
        communicator.delegate = MockStackOverflowManager()
        communicator.downloadInformationForQuestion(with: sutQuestionId)
        let manager = communicator.delegate as? MockStackOverflowManager
        XCTAssertEqual(manager?.topicFailureErrorCode, 404)
    }
}

class IntrospectionStackOverflowCommunicator: StackOverflowCommunicator {

    private func fetchContentAtUrl(with text: String) {
        let dataTask = MockDataTask()
        dataTask.statusCode = 404
        self.urlSession(self.session as! URLSession, task: dataTask, didCompleteWithError: nil)
    }

    override func searchForQuestions(with tag: String) {
        guard let encodedTag = tag.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { fatalError() }
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/search?pagesize=20&order=desc&sort=activity&tagged=\(encodedTag)&site=stackoverflow")
    }

    override func downloadInformationForQuestion(with id: Int) {
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/questions/\(id)?order=desc&sort=activity&site=stackoverflow&filter=withBody")
    }
}
