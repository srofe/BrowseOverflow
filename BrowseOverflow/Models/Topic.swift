//
//  Topic.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 9/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

struct Topic {
    let name: String
    let tag: String
    fileprivate (set) var recentQuestions: [Question] = []

    init(name: String, tag: String) {
        self.name = name
        self.tag = tag
    }

    mutating func add(question: Question) {
        recentQuestions.append(question)
        recentQuestions = recentQuestions.sorted(by: { $0.date > $1.date })
    }
}
