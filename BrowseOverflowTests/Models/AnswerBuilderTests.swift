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

    func testSendingNonJsonIsAnError() {
        let answerBuilder = AnswerBuilder()
        let question = Question()
        XCTAssertThrowsError(try answerBuilder.addAnswer(to: question, containing: "Not JSON"), "An AnswerBuilder shall raise an exception if passed invalid JSON.") { error in
            XCTAssertEqual(error as? AnswerBuilderError, AnswerBuilderError.invalidJson, "An AnswerBuilder shall set the error type to invalidJson if passed invalid JSON.")
        }
    }

    func testSendingValidJsonIsNotAnError() {
        let answerBuilder = AnswerBuilder()
        let question = Question()
        XCTAssertNoThrow(try answerBuilder.addAnswer(to: question, containing: answerJson()), "An AnswerBuilder shall not raise an exception if passed valid JSON.")
    }
}

extension AnswerBuilderTests {
    func answerJson() -> String {
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
