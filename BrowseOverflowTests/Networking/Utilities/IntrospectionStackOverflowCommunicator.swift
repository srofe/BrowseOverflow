//
//  IntrospectionStackOverflowCommunicator.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 18/6/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation
@testable import BrowseOverflow

class IntrospectionStackOverflowCommunicator: StackOverflowCommunicator {

    private func fetchContentAtUrl(with text: String) {
        let dataTask = MockDataTask()
        dataTask.statusCode = 404
        self.urlSession(self.session as! URLSession, task: dataTask, didCompleteWithError: nil)
    }

    override func searchForQuestions(with tag: String) {
        guard let encodedTag = tag.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { fatalError() }
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/search?pagesize=20&order=desc&sort=activity&tagged=\(encodedTag)&site=stackoverflow")
    }

    override func downloadInformationForQuestion(with id: Int) {
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/questions/\(id)?order=desc&sort=activity&site=stackoverflow&filter=withBody")
    }

    override func downloadAnswersToQuestion(with id: Int) {
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/questions/\(id)/answers?order=desc&sort=activity&site=stackoverflow")
    }
}
