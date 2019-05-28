//
//  QuestionBuilderTests.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 28/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import BrowseOverflow

class QuestionBuilderTests: XCTestCase {

    // The System Under Test - a QuestionBuilder
    var sut: QuestionBuilder!

    let sutNotJson = "Not JSON"
    let sutValidJson = "{ \"noquestions\": true }"
    var sutQuestionJson: String = ""

    override func setUp() {
        super.setUp()
        sut = QuestionBuilder()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testErrorThrownWhenStringIsInvalidJson() {
        XCTAssertThrowsError(try sut.questionsFrom(json: sutNotJson), "A QuestionBuilder shall raise an exception if passed an non-JSON string.") { error in
            XCTAssertEqual(error as? QuestionBuilderError, QuestionBuilderError.invalidJson, "A QuestionBuilder shall set the error type to invalid JSON if the JSON is not valid.")
        }
    }

    func testErrorThrownWhenJsonHasNoQuestions() {
        XCTAssertThrowsError(try sut.questionsFrom(json: sutValidJson), "A QuestionBuilder shall throw a QuestionsBuilder error if question data is missing.") { error in
            XCTAssertEqual(error as? QuestionBuilderError, QuestionBuilderError.missingData, "A QuestionBuilder shall set the error type to missing data if the JSON is valid and there is no question data.")
        }
    }

    func testJsonWithOneQuestionsReturnsOneQuestionObject() {
        let questions = try? sut.questionsFrom(json: questionJson())
        XCTAssertEqual(questions?.count, 1, "The QuestionBuilder shall create one Question object from JSON containing one question.")
    }

    func testQuestionCreatedFromJsonHasPropertiesFromJson() {
        let questions = try? sut.questionsFrom(json: questionJson())
        let question = questions?[0]
        XCTAssertEqual(question?.title, "Why does Keychain Services return the wrong keychain content?", "")
    }
}

extension QuestionBuilderTests {
    func questionJson() -> String {
        return "{" +
            "\"total\": 1," +
            "\"page\": 1," +
            "\"pagesize\": 30," +
            "\"questions\": [" +
            "{" +
            "\"tags\": [" +
            "\"iphone\"," +
            "\"security\"," +
            "\"keychain\"" +
            "]," +
            "\"answer_count\": 1," +
            "\"accepted_answer_id\": 3231900," +
            "\"favorite_count\": 1," +
            "\"question_timeline_url\": \"/questions/2817980/timeline\"," +
            "\"question_comments_url\": \"/questions/2817980/comments\"," +
            "\"question_answers_url\": \"/questions/2817980/answers\"," +
            "\"question_id\": 2817980," +
            "\"owner\": {" +
            "\"user_id\": 23743," +
            "\"user_type\": \"registered\"," +
            "\"display_name\": \"Graham Lee\"," +
            "\"reputation\": 13459," +
            "\"email_hash\": \"563290c0c1b776a315b36e863b388a0c\"" +
            "}," +
            "\"creation_date\": 1273660706," +
            "\"last_activity_date\": 1278965736," +
            "\"up_vote_count\": 2," +
            "\"down_vote_count\": 0," +
            "\"view_count\": 465," +
            "\"score\": 2," +
            "\"community_owned\": false," +
            "\"title\": \"Why does Keychain Services return the wrong keychain content?\"," +
            "\"body\": \"<p>I've been trying to use persistent keychain references.</p>\"" +
            "}" +
            "]" +
        "}"
    }
}
