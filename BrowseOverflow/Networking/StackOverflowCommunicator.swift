//
//  StackOverflowCommunicator.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 31/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

protocol SessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession : SessionProtocol {}

class StackOverflowCommunicator {
    lazy var session: SessionProtocol = URLSession.shared
    private (set) var fetchingUrl: URL? = nil

    private func fetchContentAtUrl(with text: String) {
        guard let url = URL(string: text) else { fatalError() }
        _ =  session.dataTask(with: url) { (data, response, error) in }
        fetchingUrl = url
    }

    func searchForQuestions(with tag: String) {
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/search?pagesize=20&order=desc&sort=activity&tagged=\(tag)&site=stackoverflow")
    }

    func downloadInformationForQuestion(with id: Int) {
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/questions/\(id)?order=desc&sort=activity&site=stackoverflow&filter=withBody")
    }

    func downloadAnswersToQuestion(with id: Int) {
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/questions/\(id)/answers?order=desc&sort=activity&site=stackoverflow")
    }
}
