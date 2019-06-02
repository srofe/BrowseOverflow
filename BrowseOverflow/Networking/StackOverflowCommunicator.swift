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

    private func fetchContentAtUrl(with text: String) {
        fetchingUrl = URL(string: text)
    }

    func searchForQuestions(with tag: String) {
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/search?pagesize=20&order=desc&sort=activity&tagged=\(tag)&site=stackoverflow")
    }

    func downloadInformationForQuestion(with id: Int) {
        fetchContentAtUrl(with: "https://api.stackexchange.com/2.2/questions/\(id)?order=desc&sort=activity&site=stackoverflow&filter=withBody")
    }
}
