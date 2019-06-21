//
//  MockStackOverflowManager.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 18/6/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation
@testable import BrowseOverflow

class MockStackOverflowManager: StackOverflowManager, StackOverflowCommunicatorDelegate {
    var topicFailureErrorCode = 0
    var bodyFailureErrorCode = 0
    var answerFailureErrorCode = 0
    var topicSearchString = ""
    var bodySearchString = ""

    override func received(questionsJson: String) {
        topicSearchString = questionsJson
    }

    override func received(questionBodyJson: String) {
        bodySearchString = questionBodyJson
    }

    override func searchingForQuestionsFailed(with error: Error) {
        if let error = error as? StackOverflowCommunicatorError {
            topicFailureErrorCode = error.errorCode
        }
        if error is TestError {
            topicFailureErrorCode = 999
        }
    }

    override func fetchingQuestionFailed(with error: Error) {
        if let error = error as? StackOverflowCommunicatorError {
            bodyFailureErrorCode = error.errorCode
        }
        if error is TestError {
            bodyFailureErrorCode = 999
        }
    }

    override func fetchingAnswersFailed(with error: Error) {
        if let error = error as? StackOverflowCommunicatorError {
            answerFailureErrorCode = error.errorCode
        }
        if error is TestError {
            answerFailureErrorCode = 999
        }
    }
}
