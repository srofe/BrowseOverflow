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
    var questions: [Question]? { get }
    func fetchingQuestionsFailed(error: Error)
    func didReceiveQuestions(questions: [Question])
}

protocol StackOverflowCommunicator {
    func searchForQuestions(with tag: String)
    func downloadInformationQuestion(id: Int)
}

fileprivate let StackOverflowManagerError = "StackOverflowManagerError"

struct StackOverflowError: Error {
    enum ErrorKind {
        case questionSearch
        case questionBodyFetch
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
    var questionBuilder: QuestionBuilderProtocol? = nil

    func fetchQuestions(on topic: Topic) {
        communicator?.searchForQuestions(with: topic.tag)
    }

    func searchingForQuestionsFailed(with error: Error) {
        tellDelegateAboutError(kind: .questionSearch, underlyingError: error)
    }

    func fetchBody(for question: Question) {
        communicator?.downloadInformationQuestion(id: question.id)
    }

    func fetchingQuestionFailed(with error: Error) {
        tellDelegateAboutError(kind: .questionBodyFetch, underlyingError: error)
    }

    func received(questionsJson: String) {
        do {
            if let questions = try questionBuilder?.questionsFrom(json: questionsJson) {
                delegate?.didReceiveQuestions(questions: questions)
            } else {
                tellDelegateAboutError(kind: .questionSearch, underlyingError: nil)
            }
        } catch let underlyingError {
            tellDelegateAboutError(kind: .questionSearch, underlyingError: underlyingError)
        }
    }

    private func tellDelegateAboutError(kind: StackOverflowError.ErrorKind, underlyingError: Error?) {
        let reportableError = StackOverflowError(underlyingError: underlyingError, kind: kind)
        delegate?.fetchingQuestionsFailed(error: reportableError)
    }
}
