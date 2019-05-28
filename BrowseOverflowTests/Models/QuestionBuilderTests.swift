//
//  QuestionBuilderTests.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 28/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import BrowseOverflow

class QuestionBuilderTests: XCTestCase {

    // The System Under Test - a QuestionBuilder
    var sut: QuestionBuilder!

    override func setUp() {
        super.setUp()
        sut = QuestionBuilder()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
