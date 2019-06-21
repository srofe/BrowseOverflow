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

fileprivate let StackOverflowManagerError = "StackOverflowManagerError"

struct StackOverflowError: Error {
    enum ErrorKind {
        case questionSearch
        case questionBodyFetch
        case answersFetch
    }
    let underlyingError: Error?
    let kind: ErrorKind
}

enum StackOverflowErrorCode: Int {
    case QuestionSearchCode
}

class StackOverflowManager {
    var delegate: StackOverflowManagerDelegate? = nil
    var communicator: StackOverflowCommunicator? = nil
    var questionBuilder: QuestionBuilderProtocol? = nil
    var answerBuilder: AnswerBuilderProtocol? = nil
    var questionNeedingBody: Question? = nil
    var questionToFill: Question? = nil

    func fetchQuestions(on topic: Topic) {
        communicator?.searchForQuestions(with: topic.tag)
    }

    func searchingForQuestionsFailed(with error: Error) {
        tellDelegateAboutError(kind: .questionSearch, underlyingError: error)
    }

    func fetchBody(for question: Question) {
        questionNeedingBody = question
        communicator?.downloadInformationForQuestion(with: question.id)
    }

    func fetchingQuestionFailed(with error: Error) {
        tellDelegateAboutError(kind: .questionBodyFetch, underlyingError: error)
    }

    func fetchAnswers(for question: Question) {
        questionToFill = question
        communicator?.downloadAnswersToQuestion(with: question.id)
    }

    func fetchingAnswersFailed(with error: Error) {
        tellDelegateAboutError(kind: .answersFetch, underlyingError: error)
    }

    func received(questionsJson: String) {
        do {
            if let questions = try questionBuilder?.questions(from: questionsJson) {
                delegate?.didReceiveQuestions(questions: questions)
            } else {
                tellDelegateAboutError(kind: .questionSearch, underlyingError: nil)
            }
        } catch let underlyingError {
            tellDelegateAboutError(kind: .questionSearch, underlyingError: underlyingError)
        }
    }

    func received(questionBodyJson: String) {
        questionBuilder?.questionBody(for: &questionNeedingBody!, from: questionBodyJson)
        self.questionNeedingBody = nil
    }

    func received(answerJson: String) {
        do  {
            try answerBuilder?.addAnswer(to: &questionToFill!, containing: answerJson)
        } catch let underlyingError {
            tellDelegateAboutError(kind: .answersFetch, underlyingError: underlyingError)
        }
    }

    private func tellDelegateAboutError(kind: StackOverflowError.ErrorKind, underlyingError: Error?) {
        let reportableError = StackOverflowError(underlyingError: underlyingError, kind: kind)
        delegate?.fetchingQuestionsFailed(error: reportableError)
    }
}
