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

    func testViewControllerHasDelegateProperty() {
        XCTAssertTrue(sut.tableView.delegate is TopicDataProvider, "The table view delegate shall be a TopicDataProvider.")
    }

    func testOneTableRowForOneTopicInDataProvider() {
        let dataSource = TopicDataProvider()
        dataSource.topics.append(Topic(name: "iPhone", tag: "iphone"))
        XCTAssertEqual(dataSource.tableView(sut.tableView, numberOfRowsInSection: 0), 1)
    }

    func testTwoTableRowsForTwoTopicsInDataProvider() {
        let dataSource = TopicDataProvider()
        dataSource.topics.append(Topic(name: "iPhone", tag: "iphone"))
        dataSource.topics.append(Topic(name: "macOS", tag: "macos"))
        XCTAssertEqual(dataSource.tableView(sut.tableView, numberOfRowsInSection: 0), 2)
    }
}
