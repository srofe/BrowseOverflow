//
//  StackOverflowManager.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 16/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

protocol StackOverflowManagerDelegate {
    func fetchingQuestions(on topic: Topic?, error: NSError)
}

protocol StackOverflowCommunicator {
    func searchForQuestions(with tag: String)
}

fileprivate let StackOverflowManagerError = "StackOverflowManagerError"

enum StackOverflowError: Int {
    case QuestionSearchCode
}

struct StackOverflowManager {
    var delegate: StackOverflowManagerDelegate? = nil
    var communicator: StackOverflowCommunicator? = nil

    func fetchQuestions(on topic: Topic) {
        communicator?.searchForQuestions(with: topic.tag)
    }

    func searchingForQuestionsFailed(with error: NSError) {
        let errorInfo = [NSUnderlyingErrorKey:error]
        let reportableError = NSError(domain: StackOverflowManagerError, code: StackOverflowError.QuestionSearchCode.rawValue, userInfo: errorInfo)
        delegate?.fetchingQuestions(on: nil, error: reportableError)
    }
}