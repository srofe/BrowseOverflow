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

    static func < (left: Answer, right: Answer) -> Bool {
        if !left.accepted && right.accepted {
            return true
        } else if left.accepted && !right.accepted {
            return false
        }

        if left.score < right.score {
            return true
        }
        return false
    }

    func compare(with other: Answer) -> ComparisonResult {
        if accepted && !other.accepted {
            return .orderedAscending
        } else if !accepted && other.accepted {
            return .orderedDescending
        }

        if score > other.score {
            return .orderedAscending
        } else if score < other.score {
            return .orderedDescending
        }
        return .orderedSame
    }
}
