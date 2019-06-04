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
    let searchUrlWithSpace = "https://api.stackexchange.com/2.2/search?pagesize=20&order=desc&sort=activity&tagged=unit%20testing&site=stackoverflow"
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

    func testSearchingForQuestionsOnTopicCallsTopicApi() {
        sut.searchForQuestions(with: sutQueryTag)
        XCTAssertEqual(sutMockUrlSession.fetchingUrl?.absoluteString, searchUrl, "A StackOverflowCommunicator shall build a URL for searching by tags.")
    }

    func testSearchingForQuestionOnTopicWithSpacesIsValid() {
        sut.searchForQuestions(with: "unit testing")
        XCTAssertEqual(sutMockUrlSession.fetchingUrl?.absoluteString, searchUrlWithSpace, "A StackOverflowCommunicator shall allow for search terms with spaces.")
    }

    func testFillingInQuestionBodyCallsQuestionAPI() {
        sut.downloadInformationForQuestion(with: questionId)
        XCTAssertEqual(sutMockUrlSession.fetchingUrl?.absoluteString, questionUrl, "A StackOverflowCommunicator shall build a URL for downloading a question with an ID.")
    }

    func testTestAnswersToQuestionCallsQuestionApi() {
        sut.downloadAnswersToQuestion(with: questionId)
        XCTAssertEqual(sutMockUrlSession.fetchingUrl?.absoluteString, answersUrl, "A StackOverflowCommunicator shall build a URL for downloading a question with an ID.")
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
    }
}
