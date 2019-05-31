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
}

extension AnswerBuilderTests {
    func answerJson() -> String {
        // Query URL: https://api.stackexchange.com/2.2/questions/2817980/answers?order=desc&sort=activity&site=stackoverflow
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
                "\"question_id\":2817980}" +
            "]," +
            "\"has_more\":false," +
            "\"quota_max\":300," +
            "\"quota_remaining\":288" +
            "}"
    }
}
