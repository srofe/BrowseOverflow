//
//  Question.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 10/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

struct Question {
    var date: Date
    var score: Int
    var title: String

    init(date: Date = Date()) {
        self.date = date
        self.score = 0
        self.title = ""
    }
}
