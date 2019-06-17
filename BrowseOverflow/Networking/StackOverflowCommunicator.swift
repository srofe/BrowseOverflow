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

class StackOverflowCommunicator: NSObject {
    lazy var session: SessionProtocol = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    var dataTask: URLSessionDataTask?

    private func fetchContentAtUrl(with text: String) {
        guard let url = URL(string: text) else { fatalError() }
        if dataTask != nil {
            cancelDataTask()
        }
        dataTask =  session.dataTask(with: url)
        dataTask?.resume()
    }

    func searchForQuestions(with tag: String) {
        guard let encodedTag = tag.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { fatalError() }
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/search?pagesize=20&order=desc&sort=activity&tagged=\(encodedTag)&site=stackoverflow")
    }

    func downloadInformationForQuestion(with id: Int) {
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/questions/\(id)?order=desc&sort=activity&site=stackoverflow&filter=withBody")
    }

    func downloadAnswersToQuestion(with id: Int) {
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/questions/\(id)/answers?order=desc&sort=activity&site=stackoverflow")
    }

    private func cancelDataTask() {
        dataTask?.cancel()
        dataTask = nil
    }
}

extension StackOverflowCommunicator: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        cancelDataTask()
        return
    }
}
