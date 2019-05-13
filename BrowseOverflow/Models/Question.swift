//
//  Question.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 10/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

struct Question {
    var date: Date = Date()
    var score: Int = 0
    var title: String = ""
    private (set) var answers: [Answer] = []

    mutating func add(answer: Answer) {
        answers.append(answer)
    }
}
