//
//  StackOverflowCommunicator.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 31/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

class StackOverflowCommunicator {
    private (set) var fetchingUrl: URL? = nil

    func searchForQuestions(with tag: String) {
        fetchingUrl = URL(string: "https://api.stackexchange.com/2.2/search?pagesize=20&order=desc&sort=activity&tagged=\(tag)&site=stackoverflow")!
        return
    }

    func downloadInformationForQuestion(with id: Int) {
        return
    }
}
