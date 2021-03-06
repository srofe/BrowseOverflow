//
//  AnswerBuilderTests.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 31/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import BrowseOverflow

class AnswerBuilderTests: XCTestCase {

    // The System Under Test - an AnswerBuilder
    var sut: AnswerBuilder!

    let sutNotJson = "Not JSON"
    let sutValidJson = "{ \"noanswers\": true }"
    var sutAnswerJson: String!

    override func setUp() {
        super.setUp()
        sut = AnswerBuilder()
        sutAnswerJson = answerJson()
    }

    override func tearDown() {
        sutAnswerJson = nil
        sut = nil
        super.tearDown()
    }

    func testSendingNonJsonIsAnError() {
        var question = Question()
        XCTAssertThrowsError(try sut.addAnswer(to: &question, containing: sutNotJson), "An AnswerBuilder shall raise an exception if passed invalid JSON.") { error in
            XCTAssertEqual(error as? AnswerBuilderError, AnswerBuilderError.invalidJson, "An AnswerBuilder shall set the error type to invalidJson if passed invalid JSON.")
        }
    }

    func testSendingValidJsonIsNotAnError() {
        var question = Question()
        XCTAssertNoThrow(try sut.addAnswer(to: &question, containing: sutAnswerJson), "An AnswerBuilder shall not raise an exception if passed valid JSON.")
    }

    func testSendingValidJsonWithNoAnswersIsAnError() {
        var question = Question()
        XCTAssertThrowsError(try sut.addAnswer(to: &question, containing: sutValidJson), "An AnswerBuilder shall raise an exception if passed valid JSON with no Answers.") { error in
            XCTAssertEqual(error as? AnswerBuilderError, AnswerBuilderError.missionData, "An AnswerBuilder shall set the error type to missingData if passed JSON with no Answers.")
        }
    }

    func testSendingValidAnswerAddsAnAnswer() {
        var question = Question()
        try? sut.addAnswer(to: &question, containing: sutAnswerJson)
        XCTAssertEqual(question.answers.count, 1, "An AnsewrBuilder shall add an Answer if the JSON is valid and contains an Answer.")
    }

    func testValidAnswerIsDecoded() {
        var question = Question()
        try? sut.addAnswer(to: &question, containing: sutAnswerJson)
        let answer = question.answers.first
        XCTAssertEqual(answer?.text, "This is the Answer!", "An AnswerBuilder shall add an Answer with the correct text if the JSON is valid and contains and Answer.")
        XCTAssertEqual(answer?.accepted, true, "An AnswerBuilder shall add an Answer with the correct accepted flag if the JSON is valid and contains and Answer.")
        XCTAssertEqual(answer?.score, 1, "An AnswerBuilder shall add an Answer with the correct score if the JSON is valid and contains and Answer.")
    }

    func testValidAnswerPersonIsDecoded() {
        var question = Question()
        try? sut.addAnswer(to: &question, containing: sutAnswerJson)
        let answer = question.answers.first
        let answerer = Person(name: "dmaclach", avatarUrl: URL(string: "https://i.stack.imgur.com/GmE6g.png?s=128&g=1")!)
        XCTAssertEqual(answer?.person, answerer, "An AnswerBuilder shall add an Answer with the correct person if the JSON is valid and contains and Answer.")
    }
}

extension AnswerBuilderTests {
    func answerJson() -> String {
        // Query URL: https://api.stackexchange.com/2.2/questions/2817980/answers?order=desc&sort=activity&site=stackoverflow&filter=withBody
        // Note: Shortened the answer body as the original did not appear to be valid JSON!
        return
            "{\"items\":[" +
                "{\"owner\":{" +
                    "\"reputation\":1524," +
                    "\"user_id\":266380," +
                    "\"user_type\":\"registered\"," +
                    "\"accept_rate\":50," +
                    "\"profile_image\":\"https://i.stack.imgur.com/GmE6g.png?s=128&g=1\"" +
                    ",\"display_name\":\"dmaclach\"," +
                    "\"link\":\"https://stackoverflow.com/users/266380/dmaclach\"" +
                "}," +
                "\"is_accepted\":true," +
                "\"score\":1," +
                "\"last_activity_date\":1278965736," +
                "\"creation_date\":1278965736," +
                "\"answer_id\":3231900," +
                "\"question_id\":2817980," +
                "\"body\":\"This is the Answer!\"}" +
            "]," +
            "\"has_more\":false," +
            "\"quota_max\":300," +
            "\"quota_remaining\":288" +
            "}"
    }
}
