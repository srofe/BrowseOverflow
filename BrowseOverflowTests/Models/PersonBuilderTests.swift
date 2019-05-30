//
//  PersonBuilderTests.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 30/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import BrowseOverflow

class PersonBuilderTests: XCTestCase {

    func testPersonBuilderFindsPeronsName() {
        let userDictionary = [
            "display_name":"Joe Bloggs",
            "email_hash":"1234567890"]
        let person = PersonBuilder.personFrom(userDictionary: userDictionary)
        XCTAssertEqual(person.name, "Joe Bloggs", "A PersonBuilder shall decode the name field.")
    }
}
