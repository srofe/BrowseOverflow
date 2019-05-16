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

    override func setUp() {
        super.setUp()
        sut = StackOverflowManager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testAskingForQuestionsMeansRequestingData() {
        let communicator = MockStackOverflowCommunicator()
        sut.communicator = communicator
        let topic = Topic(name: "iPhone", tag: "iphone")
        sut.fetchQuestions(on: topic)
        XCTAssertTrue((sut.communicator as? MockStackOverflowCommunicator)!.wasAskedToFetchQuestions, "The communicator shall be asked to fetch data when request with a topic.")
    }
}

class MockStackOverflowCommunicator : StackOverflowCommunicator {
    var wasAskedToFetchQuestions = false
    func searchForQuestions(with tag: String) {
        wasAskedToFetchQuestions = true
    }
}
