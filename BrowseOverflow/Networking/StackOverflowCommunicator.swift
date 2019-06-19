//
//  StackOverflowCommunicator.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 31/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

protocol SessionProtocol {
    func dataTask(with url: URL) -> URLSessionDataTask
}

extension URLSession : SessionProtocol {}

protocol StackOverflowCommunicatorDelegate {
    func searchingForQuestionsFailed(with error: Error)
    func fetchingQuestionBodyFailed(with error: Error)
    func fetchingAnswersFailed(with error: Error)
}

struct StackOverflowCommunicatorError: Error {
    enum Kind {
        case statusError
    }
    let errorCode: Int
    let kind: Kind
}

class StackOverflowCommunicator: NSObject {
    enum FetchType {
        case topic
        case question
        case answer
    }

    lazy var session: SessionProtocol = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    var dataTask: URLSessionDataTask?
    var delegate: StackOverflowCommunicatorDelegate?
    var fetchType: FetchType?

    func fetchContentAtUrl(with text: String) {
        guard let url = URL(string: text) else { fatalError() }
        if dataTask != nil {
            cancelDataTask()
        }
        dataTask =  session.dataTask(with: url)
        dataTask?.resume()
    }

    func searchForQuestions(with tag: String) {
        guard let encodedTag = tag.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { fatalError() }
        fetchType = .topic
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/search?pagesize=20&order=desc&sort=activity&tagged=\(encodedTag)&site=stackoverflow")
    }

    func downloadInformationForQuestion(with id: Int) {
        fetchType = .question
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/questions/\(id)?order=desc&sort=activity&site=stackoverflow&filter=withBody")
    }

    func downloadAnswersToQuestion(with id: Int) {
        fetchType = .answer
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/questions/\(id)/answers?order=desc&sort=activity&site=stackoverflow")
    }

    private func cancelDataTask() {
        dataTask?.cancel()
        dataTask = nil
    }
}

extension StackOverflowCommunicator: URLSessionDataDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            sendErrorToDelegate(error)
        } else if let response = task.response as? HTTPURLResponse {
            if response.statusCode == 404 {
                let error = StackOverflowCommunicatorError(errorCode: response.statusCode, kind: .statusError)
                sendErrorToDelegate(error)
            }
        }
        cancelDataTask()
        return
    }

    fileprivate func sendErrorToDelegate(_ error: Error) {
        if let fetchType = self.fetchType {
            switch fetchType {
            case .topic: delegate?.searchingForQuestionsFailed(with: error)
            case .question: delegate?.fetchingQuestionBodyFailed(with: error)
            case .answer: delegate?.fetchingAnswersFailed(with: error)
            }
        }
    }
}
