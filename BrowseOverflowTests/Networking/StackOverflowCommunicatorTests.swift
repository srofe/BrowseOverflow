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

    // Test URL strings.
    var sutMockUrlSession: MockURLSession!
    let sutHost = "api.stackexchange.com"
    let sutSearchPath = "/2.2/search"
    let sutQueryTag = "ios"
    let questionId = 12345
    let searchUrl = "https://api.stackexchange.com/2.2/search?pagesize=20&order=desc&sort=activity&tagged=ios&site=stackoverflow"
    let questionUrl = "https://api.stackexchange.com/2.2/questions/12345?order=desc&sort=activity&site=stackoverflow&filter=withBody"
    let answersUrl = "https://api.stackexchange.com/2.2/questions/12345/answers?order=desc&sort=activity&site=stackoverflow"

    override func setUp() {
        super.setUp()
        sut = StackOverflowCommunicator()
        sutMockUrlSession = MockURLSession()
        sut.session = sutMockUrlSession
    }

    override func tearDown() {
        sutMockUrlSession = nil
        sut = nil
        super.tearDown()
    }

    func testFillingInQuestionBodyCallsQuestionAPI() {
        sut.downloadInformationForQuestion(with: questionId)
        XCTAssertEqual(sut.fetchingUrl?.absoluteString, questionUrl, "A StackOverflowCommunicator shall build a URL for downloading a question with an ID.")
    }

    func testTestAnswersToQuestionCallsQuestionApi() {
        sut.downloadAnswersToQuestion(with: questionId)
        XCTAssertEqual(sut.fetchingUrl?.absoluteString, answersUrl, "A StackOverflowCommunicator shall build a URL for downloading a question with an ID.")
    }

    func testSearchingForQuestionsOnATopicUsesExpectedHost() {
        sut.searchForQuestions(with: sutQueryTag)
        XCTAssertEqual(sutMockUrlSession.urlComponents?.host, sutHost, "The host name for the URL shall be the stackexchange host.")
    }

    func testSearchingForQuestionsOnATopicUsesTheSeachPath() {
        sut.searchForQuestions(with: sutQueryTag)
        XCTAssertEqual(sutMockUrlSession.urlComponents?.path, sutSearchPath, "The path for the question URL shall contain the path \"\(sutSearchPath)\".")
    }

    func testSearchingForQuestionsOnATopicUsesExpectedQueryItems() {
        sut.searchForQuestions(with: sutQueryTag)
        XCTAssertEqual(sutMockUrlSession.urlComponents?.queryItems?.count, 5, "The URL shall have the correct number of query items.")
        sutMockUrlSession.verifyQueryItemContains(name: "pagesize", value: "20")
        sutMockUrlSession.verifyQueryItemContains(name: "order", value: "desc")
        sutMockUrlSession.verifyQueryItemContains(name: "sort", value: "activity")
        sutMockUrlSession.verifyQueryItemContains(name: "tagged", value: sutQueryTag)
        sutMockUrlSession.verifyQueryItemContains(name: "site", value: "stackoverflow")
    }
}

extension StackOverflowCommunicatorTests {

    class MockURLSession : SessionProtocol {
        var fetchingUrl: URL?
        var urlComponents: URLComponents? {
            guard let url = fetchingUrl else { return nil }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }

        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.fetchingUrl = url

            return URLSession.shared.dataTask(with: url)
        }

        func verifyQueryItemContains(name: String, value: String, file: StaticString = #file, line: UInt = #line) {
            let queryItem = URLQueryItem(name: name, value: value)
            guard let queryItems = urlComponents?.queryItems else {
                XCTFail("The URL contains no query items: \"\( fetchingUrl?.absoluteString ?? "")\".", file: file, line: line)
                return
            }
            XCTAssertTrue(queryItems.contains(queryItem), "URL query does not contain parameter with name \"\(name)\" and/or value \"\(value)\".", file: file, line: line)
        }
    }
}
