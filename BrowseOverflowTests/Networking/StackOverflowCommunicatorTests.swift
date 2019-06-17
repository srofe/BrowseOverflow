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
}

extension StackOverflowCommunicatorTests {

    class MockURLSession : SessionProtocol {
        var dataTask: MockDataTask?
        var fetchingUrl: [URL] = []
        var urlComponents: URLComponents? {
            guard let url = fetchingUrl.first else { return nil }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }

        func dataTask(with url: URL) -> URLSessionDataTask {
            self.fetchingUrl.append(url)
            dataTask = MockDataTask()
            return dataTask!
        }
    }

    class MockDataTask: URLSessionDataTask {
        var resumeCalled = false
        var cancelCalled = false

        override func resume() {
            resumeCalled = true
        }

        override func cancel() {
            cancelCalled = true
        }
    }
}

extension XCTest {
    typealias URLItems = (host: String, path: String, items: [String:String])

    func AssertEquivalent(url: URL, urlElements: URLItems, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
        guard let urlPathComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            XCTFail("URL \"\(url.absoluteString)\" is not valid - \(message()).", file: file, line: line)
            return
        }
        guard urlPathComponents.host == urlElements.host else {
            XCTFail("URL host component \"\(urlPathComponents.host!)\" does not equal \"\(urlElements.host)\" - \(message()).", file: file, line: line)
            return
        }
        guard urlPathComponents.path == urlElements.path else {
            XCTFail("URL path component \"\(urlPathComponents.path)\" does not equal \"\(urlElements.path)\" - \(message()).", file: file, line: line)
            return
        }
        guard let queryItems = urlPathComponents.queryItems else {
            XCTFail("URL query parameters missing - \(message()).", file: file, line: line)
            return
        }
        guard queryItems.count == urlElements.items.count else {
            XCTFail("URL query item count \"\(queryItems.count)\" does not equal \"\(urlElements.items.count)\" - \(message()).", file: file, line: line)
            return
        }
        for item in urlElements.items {
            let queryItem = URLQueryItem(name: item.key, value: item.value)
            guard (urlPathComponents.queryItems?.contains(queryItem))! else {
                XCTFail("URL query does not contain parameters with name \"\(item.key)\" and/or value \"\(item.value)\".", file: file, line: line)
                return
            }
        }
    }
}
