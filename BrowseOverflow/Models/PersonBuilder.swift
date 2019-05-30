//
//  PersonBuilder.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 30/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

struct PersonBuilder {

    static func personFrom(userDictionary: [String:String]) -> Person {
        let name = userDictionary["display_name"] ?? ""
        return Person(name: name, avatarUrl: URL(string: "http://")!)
    }
}
