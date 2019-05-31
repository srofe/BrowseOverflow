//
//  StackOverflowCommunicator.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 31/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

protocol StackOverflowCommunicatorProtocol {
    mutating func searchForQuestions(with tag: String)
    func downloadInformationQuestion(id: Int)
}

struct StackOverflowCommunicator : StackOverflowCommunicatorProtocol {
    private (set) var fetchingUrl: URL? = nil

    mutating func searchForQuestions(with tag: String) {
        fetchingUrl = URL(string: "https://api.stackexchange.com/2.2/search?pagesize=20&order=desc&sort=activity&tagged=\(tag)&site=stackoverflow")!
        return
    }

    func downloadInformationQuestion(id: Int) {
        return
    }
}
