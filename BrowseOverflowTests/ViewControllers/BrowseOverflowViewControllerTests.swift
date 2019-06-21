//
//  BrowseOverflowViewControllerTests.swift
//  BrowseOverflowTests
//
//  Created by Simon Rofe on 21/6/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import XCTest
@testable import BrowseOverflow

class BrowseOverflowViewControllerTests: XCTestCase {

    // The System Under Test - a BrowseOverflowViewController
    var sut: BrowseOverflowViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "BrowseOverflowViewController") as? BrowseOverflowViewController
        sut.loadViewIfNeeded()
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testViewControllerHasTableViewProperty() {
        XCTAssertNotNil(sut.tableView, "A BrowseOverflowViewController shall have a table view.")
    }

    func testViewControllerHasDataSourceProperty() {
        XCTAssertTrue(sut.tableView.dataSource is TopicDataProvider, "The table view data source shall be a TopicDataProvider.")
    }
}
