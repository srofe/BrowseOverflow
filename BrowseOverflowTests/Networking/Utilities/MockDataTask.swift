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

    override var response: URLResponse? {
        get {
            let url = URL(string: "http://example.com")
            return HTTPURLResponse(url: url!, statusCode: self.statusCode, httpVersion: nil, headerFields: nil)
        }
    }
    var resumeCalled = false
    var cancelCalled = false
    var statusCode = 200
    
    override func resume() {
        resumeCalled = true
    }
    
    override func cancel() {
        cancelCalled = true
    }
}
