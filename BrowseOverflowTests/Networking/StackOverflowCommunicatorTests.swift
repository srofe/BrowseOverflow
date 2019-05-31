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

    func testSearchingForQuestionsOnTopicCallsTopicApi() {
        var communicator = StackOverflowCommunicator()
        communicator.searchForQuestions(with: "ios")
        XCTAssertEqual(communicator.fetchingUrl?.absoluteString, "https://api.stackexchange.com/2.2/search?pagesize=20&order=desc&sort=activity&tagged=ios&site=stackoverflow", "A StackOverflowCommunicator shall build a URL for searching by tags.")
    }
}
