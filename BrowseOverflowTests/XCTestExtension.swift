//
//  XCTestExtension.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 17/6/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest

extension XCTest {
    typealias URLItems = (host: String, path: String, items: [String:String])
    
    func AssertEquivalent(url: URL, urlElements: URLItems, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
        guard let urlPathComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            XCTFail("URL \"\(url.absoluteString)\" is not valid - \(message()).", file: file, line: line)
            return
        }
        guard urlPathComponents.host == urlElements.host else {
            XCTFail("URL host component \"\(urlPathComponents.host!)\" does not equal \"\(urlElements.host)\" - \(message()).", file: file, line: line)
            return
        }
        guard urlPathComponents.path == urlElements.path else {
            XCTFail("URL path component \"\(urlPathComponents.path)\" does not equal \"\(urlElements.path)\" - \(message()).", file: file, line: line)
            return
        }
        guard let queryItems = urlPathComponents.queryItems else {
            XCTFail("URL query parameters missing - \(message()).", file: file, line: line)
            return
        }
        guard queryItems.count == urlElements.items.count else {
            XCTFail("URL query item count \"\(queryItems.count)\" does not equal \"\(urlElements.items.count)\" - \(message()).", file: file, line: line)
            return
        }
        for item in urlElements.items {
            let queryItem = URLQueryItem(name: item.key, value: item.value)
            guard (urlPathComponents.queryItems?.contains(queryItem))! else {
                XCTFail("URL query does not contain parameters with name \"\(item.key)\" and/or value \"\(item.value)\".", file: file, line: line)
                return
            }
        }
    }
}
