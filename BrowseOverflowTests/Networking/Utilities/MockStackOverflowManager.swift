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

    override func searchingForQuestionsFailed(with error: Error) {
        if let error = error as? StackOverflowCommunicatorError {
            topicFailureErrorCode = error.errorCode
        }
    }
}
