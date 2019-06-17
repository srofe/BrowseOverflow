//
//  MockDataTask.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 17/6/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation
@testable import BrowseOverflow

class MockDataTask: URLSessionDataTask {
    var resumeCalled = false
    var cancelCalled = false
    
    override func resume() {
        resumeCalled = true
    }
    
    override func cancel() {
        cancelCalled = true
    }
}
