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
    var sutQuestionJson: String!

    override func setUp() {
        super.setUp()
        sut = QuestionBuilder()
        sutQuestionJson = questionJson()
    }

    override func tearDown() {
        sutQuestionJson = nil
        sut = nil
        super.tearDown()
    }

    func testErrorThrownWhenStringIsInvalidJson() {
        XCTAssertThrowsError(try sut.questions(from: sutNotJson), "A QuestionBuilder shall raise an exception if passed an non-JSON string.") { error in
            XCTAssertEqual(error as? QuestionBuilderError, QuestionBuilderError.invalidJson, "A QuestionBuilder shall set the error type to invalid JSON if the JSON is not valid.")
        }
    }

    func testErrorThrownWhenJsonHasNoQuestions() {
        XCTAssertThrowsError(try sut.questions(from: sutValidJson), "A QuestionBuilder shall throw a QuestionsBuilder error if question data is missing.") { error in
            XCTAssertEqual(error as? QuestionBuilderError, QuestionBuilderError.missingData, "A QuestionBuilder shall set the error type to missing data if the JSON is valid and there is no question data.")
        }
    }

    func testJsonWithOneQuestionsReturnsOneQuestionObject() {
        let questions = try? sut.questions(from: questionJson())
        XCTAssertEqual(questions?.count, 1, "The QuestionBuilder shall create one Question object from JSON containing one question.")
    }

    func testQuestionCreatedFromJsonHasPropertiesFromJson() {
        let questions = try? sut.questions(from: questionJson())
        let question = questions?[0]
        let asker = Person(name: "Francesco", avatarUrl: URL(string: "https://www.gravatar.com/avatar/8b6f2ee2c4710816c4f5f1697b7add06?s=128&d=identicon&r=PG")!)
        XCTAssertEqual(question?.id, 3047337, "The QuestionBuilder shall extract the id from the JSON.")
        XCTAssertEqual(question?.date.timeIntervalSince1970, 1276621100, "The QuestionBuilder shall extract the date from the JSON.")
        XCTAssertEqual(question?.score, 110, "The QuestionBuilder shall extract the score from the JSON.")
        XCTAssertEqual(question?.title, "Does overflow:hidden applied to &lt;body&gt; work on iPhone Safari?")
        XCTAssertEqual(question?.asker?.name, asker.name, "The QuestionBuilder shall extract the askers name.")
        XCTAssertEqual(question?.asker?.avatarUrl, asker.avatarUrl, "The QuestionBuilder shall extract the askers avarar URL.")
    }

    func testQuestionCreatedFromEmptyObjectIsStillValidObject() {
        let questions = try? sut.questions(from: "{ \"items\": [ { } ] }")
        XCTAssertEqual(questions?.count, 1, "A QuestionBuilder shall accept an empty question.")
    }

    func testNonJsonDataDoesNotCauseABodyToBeAddedToAQuestion() {
        var question = Question()
        question.title = "A Test Question"
        sut.questionBody(for: &question, from: "Not JSON")
        XCTAssertNil(question.body, "A QuestionBuilder shall not provide a body if the JSON is not valid.")
    }

    func testJsonWhichDoesNotContainABodyDoesNotCayseABodyToBeAdded() {
        var question = Question()
        question.title = "A Test Question"
        sut.questionBody(for: &question, from: sutValidJson)
        XCTAssertNil(question.body, "A QuestionBuilder shall not provide a body if the JSON contains no body.")
    }

    func testBodyContainedInJsonIsAddedToBody() {
        var question = Question()
        question.title = "A Test Question"
        sut.questionBody(for: &question, from: sutQuestionJson)
        XCTAssertEqual(question.body, questionBody())
    }
}

extension QuestionBuilderTests {
    // Query URL: https://api.stackexchange.com/2.2/questions/3047337?order=desc&sort=activity&site=stackoverflow&filter=withBody
    func questionJson() -> String {
        return "{\"items\": [{" +
            "\"tags\": [" +
            "\"iphone\"," +
            "\"css\"," +
            "\"ipad\"," +
            "\"safari\"," +
            "\"overflow\"" +
            "]," +
            "\"owner\": {" +
            "\"reputation\": 12181," +
            "\"user_id\": 282772," +
            "\"user_type\": \"registered\"," +
            "\"accept_rate\": 54," +
            "\"profile_image\": \"https://www.gravatar.com/avatar/8b6f2ee2c4710816c4f5f1697b7add06?s=128&d=identicon&r=PG\"," +
            "\"display_name\": \"Francesco\"," +
            "\"link\": \"https://stackoverflow.com/users/282772/francesco\"" +
            "}," +
            "\"is_answered\": true," +
            "\"view_count\": 111978," +
            "\"answer_count\": 14," +
            "\"score\": 110," +
            "\"last_activity_date\": 1559262344," +
            "\"creation_date\": 1276621100," +
            "\"last_edit_date\": 1446450175," +
            "\"question_id\": 3047337," +
            "\"link\": \"https://stackoverflow.com/questions/3047337/does-overflowhidden-applied-to-body-work-on-iphone-safari\"," +
            "\"title\": \"Does overflow:hidden applied to &lt;body&gt; work on iPhone Safari?\"," +
            "\"body\":\"<p>Does <code>overflow:hidden</code> applied to <code>&lt;body&gt;</code> work on iPhone Safari? It seems not.\\nI can't create a wrapper on the whole website to achieve that...</p>\\n\\n<p>Do you know the solution?</p>\\n\\n<p>Example: I have a long page, and simply I want to hide the content that goes underneath the \\\"fold\\\", and it should work on iPhone/iPad.</p>\\n\"" +
            "}]," +
            "\"has_more\": false," +
            "\"quota_max\": 10000," +
            "\"quota_remaining\": 9902" +
        "}"
    }

    func questionBody() -> String {
        return "<p>Does <code>overflow:hidden</code> applied to <code>&lt;body&gt;</code> work on iPhone Safari? It seems not.\nI can't create a wrapper on the whole website to achieve that...</p>\n\n<p>Do you know the solution?</p>\n\n<p>Example: I have a long page, and simply I want to hide the content that goes underneath the \"fold\", and it should work on iPhone/iPad.</p>\n"
    }
}
