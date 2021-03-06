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
        sut.add(question: question)
        XCTAssertEqual(sut.recentQuestions.count, 1, "Adding a Question to a Topic shall increase the number of Questions by one.")
    }

    func testQuestionsListedChronologicallyLatestAddedSecond() {
        var questionOne = Question()
        questionOne.date = Date.distantPast
        var questionTwo = Question()
        questionTwo.date = Date.distantFuture
        sut.add(question: questionOne)
        sut.add(question: questionTwo)
        let firstQuestion = sut.recentQuestions[0]
        let secondQuestion = sut.recentQuestions[1]
        XCTAssertTrue(firstQuestion.date > secondQuestion.date, "A Topic should order Questions so the latest is first in the list.")
    }

    func testQuestionsListSortedChronologicallyLaterAddedFirst() {
        var questionOne = Question()
        questionOne.date = Date.distantFuture
        var questionTwo = Question()
        questionTwo.date = Date.distantPast
        sut.add(question: questionOne)
        sut.add(question: questionTwo)
        let firstQuestion = sut.recentQuestions[0]
        let secondQuestion = sut.recentQuestions[1]
        XCTAssertTrue(firstQuestion.date > secondQuestion.date, "A Topic should order Questions so the latest is first in the list.")

    }

    func testListOfQuestionsLimitedToTwenty() {
        let question = Question()
        for _ in 1...25 {
            sut.add(question: question)
        }
        XCTAssertEqual(sut.recentQuestions.count, 20, "A Topic shall have a maximum of 20 questions.")
    }
}
