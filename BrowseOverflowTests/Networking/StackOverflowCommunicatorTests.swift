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
    let questionId = 12345
    let searchUrl = "https://api.stackexchange.com/2.2/search?pagesize=20&order=desc&sort=activity&tagged=ios&site=stackoverflow"
    let questionUrl = "https://api.stackexchange.com/2.2/questions/12345?order=desc&sort=activity&site=stackoverflow&filter=withBody"
    let answersUrl = "https://api.stackexchange.com/2.2/questions/12345/answers?order=desc&sort=activity&site=stackoverflow"

    override func setUp() {
        super.setUp()
        sut = StackOverflowCommunicator()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSearchingForQuestionsOnTopicCallsTopicApi() {
        sut.searchForQuestions(with: "ios")
        XCTAssertEqual(sut.fetchingUrl?.absoluteString, searchUrl, "A StackOverflowCommunicator shall build a URL for searching by tags.")
    }

    func testFillingInQuestionBodyCallsQuestionAPI() {
        sut.downloadInformationForQuestion(with: questionId)
        XCTAssertEqual(sut.fetchingUrl?.absoluteString, questionUrl, "A StackOverflowCommunicator shall build a URL for downloading a question with an ID.")
    }

    func testTestAnswersToQuestionCallsQuestionApi() {
        sut.downloadAnswersToQuestion(with: questionId)
        XCTAssertEqual(sut.fetchingUrl?.absoluteString, answersUrl, "A StackOverflowCommunicator shall build a URL for downloading a question with an ID.")
    }
}
