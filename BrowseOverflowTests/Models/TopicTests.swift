//
//  TopicTests.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 9/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import BrowseOverflow

class TopicTests: XCTestCase {

    // The System Under Test - a Topic.
    var sut: Topic!

    let sutTopicName = "iPhone"
    let sutTag = "iphone"

    override func setUp() {
        super.setUp()
        sut = Topic(name: sutTopicName, tag: sutTag)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testTopicCanBeCreated() {
        XCTAssertNotNil(sut, "A Topic shall be able to be created.")
    }

    func testTopicCanBeNamed() {
        XCTAssertEqual(sut.name, sutTopicName, "A Topic shall have a name.")
    }

    func testTopicHasATag() {
        XCTAssertEqual(sut.tag, sutTag, "A Topic shall have a tag.")
    }

    func testTopicHasArrayOfQuestions() {
        XCTAssertEqual(sut.recentQuestions.count, 0, "A Topic shall have an array of recent questions which is initially empty.")
    }

    func testAddingAQuestionIncreasesQuestionListByOne() {
        let question = Question()
        sut.recentQuestions.append(question)
        XCTAssertEqual(sut.recentQuestions.count, 1, "Adding a Question to a Topic shall increase the number of Questions by one.")
    }
}
