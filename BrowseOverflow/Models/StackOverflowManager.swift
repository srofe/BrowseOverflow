//
//  StackOverflowManager.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 16/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

protocol StackOverflowManagerDelegate {
    var error: Error? { get set }
    func fetchingQuestionsFailed(error: Error)
}

protocol StackOverflowCommunicator {
    func searchForQuestions(with tag: String)
}

protocol QuestionBuilder {
    func questionsFrom(json: String) throws -> [Question]?
}

fileprivate let StackOverflowManagerError = "StackOverflowManagerError"

struct StackOverflowError: Error {
    enum ErrorKind {
        case questionSearchError
    }
    let underlyingError: Error?
    let kind: ErrorKind
}

enum StackOverflowErrorCode: Int {
    case QuestionSearchCode
}

struct StackOverflowManager {
    var delegate: StackOverflowManagerDelegate? = nil
    var communicator: StackOverflowCommunicator? = nil
    var questionBuilder: QuestionBuilder? = nil

    func fetchQuestions(on topic: Topic) {
        communicator?.searchForQuestions(with: topic.tag)
    }

    func searchingForQuestionsFailed(with error: Error) {
        let reportableError = StackOverflowError(underlyingError: error, kind: .questionSearchError)
        delegate?.fetchingQuestionsFailed(error: reportableError)
    }

    func received(questionsJson: String) {
        var reportableError: StackOverflowError? = nil
        do {
            if try questionBuilder?.questionsFrom(json: questionsJson) == nil {
                reportableError = StackOverflowError(underlyingError: nil, kind: .questionSearchError)
            }
        } catch let underlyingError {
            reportableError = StackOverflowError(underlyingError: underlyingError, kind: .questionSearchError)
        }
        delegate?.fetchingQuestionsFailed(error: reportableError!)
    }
}
