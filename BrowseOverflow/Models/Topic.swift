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
    let recentQuestions: [String] = []

    init(name: String, tag: String) {
        self.name = name
        self.tag = tag
    }
}
