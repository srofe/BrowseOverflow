//
//  MockUrlSession.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 17/6/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation
@testable import BrowseOverflow

class MockURLSession : SessionProtocol {
    var dataTask: MockDataTask?
    var fetchingUrl: [URL] = []
    var urlComponents: URLComponents? {
        guard let url = fetchingUrl.first else { return nil }
        return URLComponents(url: url, resolvingAgainstBaseURL: true)
    }
    
    func dataTask(with url: URL) -> URLSessionDataTask {
        self.fetchingUrl.append(url)
        dataTask = MockDataTask()
        return dataTask!
    }
}
