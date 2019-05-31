//
//  PersonBuilder.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 30/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

struct PersonBuilder {
    static func personFrom(userDictionary: [String:Any]) -> Person {
        let name = userDictionary["display_name"] as? String ?? ""
        let profileImage = userDictionary["profile_image"] as? String ?? ""
        return Person(name: name, avatarUrl: URL(string: profileImage)!)
    }
}
