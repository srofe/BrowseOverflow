//
//  StackOverflowManager.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 16/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

protocol StackOverflowManagerDelegate {
}

protocol StackOverflowCommunicator {
    func searchForQuestions(with tag: String)
}

struct StackOverflowManager {
    var delegate: StackOverflowManagerDelegate? = nil
    var communicator: StackOverflowCommunicator? = nil

    func fetchQuestions(on topic: Topic) {
        communicator?.searchForQuestions(with: topic.tag)
    }
}
