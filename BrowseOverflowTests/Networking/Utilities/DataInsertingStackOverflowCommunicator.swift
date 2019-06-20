//
//  DataInsertingStackOverflowCommunicator.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 20/6/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation
@testable import BrowseOverflow

class DataInsertingStackOverflowCommunicator: StackOverflowCommunicator {

    override func fetchContentAtUrl(with text: String) {
        let dataTask = MockDataTask()
        self.urlSession(self.session as! URLSession, task: dataTask, didCompleteWithError: nil)
    }
}
