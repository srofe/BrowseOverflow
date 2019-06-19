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

    override func fetchContentAtUrl(with text: String) {
        let dataTask = MockDataTask()
        dataTask.statusCode = 404
        self.urlSession(self.session as! URLSession, task: dataTask, didCompleteWithError: nil)
    }
}
