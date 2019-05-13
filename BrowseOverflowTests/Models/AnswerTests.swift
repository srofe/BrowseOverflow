//
//  AnswerTests.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 13/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import BrowseOverflow

class AnswerTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testAnswerHasSomeText() {
        var answer = Answer()
        answer.text = "The answer is 42"
        XCTAssertEqual(answer.text, "The answer is 42", "An Answer has some text.")
    }

    func testSomeoneProvidedTheAnswer() {
        var answer = Answer()
        let person = Person(name: "Simon Rofe", avatarUrl: URL(string: "http://example.com/avatar.png")!)
        answer.person = person
        XCTAssertNotNil(answer.person, "An Answer shall have someone who provided it.")
    }
}
