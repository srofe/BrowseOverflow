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
        sutMockUrlSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        sut.session = sutMockUrlSession
    }

    override func tearDown() {
        sutMockUrlSession = nil
        sut = nil
        super.tearDown()
    }

    func testSearchingForQuestionsOnTopicCallsTopicApi() {
        sut.searchForQuestions(with: sutQueryTag)
        let urlElements = (sutHost, sutSearchPath, ["pagesize":"20","order":"desc","sort":"activity","tagged":"ios","site":"stackoverflow"])
        AssertEquivalent(url: sutMockUrlSession.fetchingUrl!, urlElements: urlElements, "A StackOverflowCommunicator shall build a URL for searching tags.")
    }

    func testSearchingForQuestionOnTopicWithSpacesIsValid() {
        sut.searchForQuestions(with: "unit testing")
        let urlElements = (sutHost, sutSearchPath, ["pagesize":"20","order":"desc","sort":"activity","site":"stackoverflow", "tagged":"unit testing"])
        AssertEquivalent(url: sutMockUrlSession.fetchingUrl!, urlElements: urlElements, "A StackOverflowCommunicator shall allow for search terms with spaces.")
    }

    func testFillingInQuestionBodyCallsQuestionAPI() {
        sut.downloadInformationForQuestion(with: sutQuestionId)
        let urlElements = (sutHost, sutQuestionPath, ["order":"desc","sort":"activity","site":"stackoverflow", "filter":"withBody"])
        AssertEquivalent(url: sutMockUrlSession.fetchingUrl!, urlElements: urlElements, "A StackOverflowCommunicator shall build a URL for downloading a question with an ID.")
    }

    func testTestAnswersToQuestionCallsQuestionApi() {
        sut.downloadAnswersToQuestion(with: sutQuestionId)
        let urlElements = (sutHost, sutAnswerPath, ["order":"desc","sort":"activity","site":"stackoverflow"])
        AssertEquivalent(url: sutMockUrlSession.fetchingUrl!, urlElements: urlElements, "A StackOverflowCommunicator shall build a URL for downloading a question with an ID.")
    }

}

extension StackOverflowCommunicatorTests {

    class MockURLSession : SessionProtocol {
        private let dataTask: MockTask
        var fetchingUrl: URL?
        var urlComponents: URLComponents? {
            guard let url = fetchingUrl else { return nil }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }

        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            dataTask = MockTask(data: data, urlResponse: urlResponse, error: error)
        }

        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.fetchingUrl = url
            self.dataTask.completionHandler = completionHandler

            return dataTask
        }
    }

    class MockTask : URLSessionDataTask {
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        var completionHandler: CompletionHandler?

        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = error
        }

        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.data, self.urlResponse, self.error)
            }
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
