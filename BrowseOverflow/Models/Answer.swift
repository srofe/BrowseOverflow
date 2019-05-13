//
//  Answer.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 13/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

struct Answer {
    var text: String = ""
    var person: Person = Person(name: "", avatarUrl: URL(string: "http://example.com")!)
    var accepted: Bool = false
    var score: Int = 0

    func compare(with other: Answer) -> ComparisonResult {
        if accepted && !other.accepted {
            return .orderedAscending
        } else if !accepted && other.accepted {
            return .orderedDescending
        }
        return .orderedSame
    }
}
