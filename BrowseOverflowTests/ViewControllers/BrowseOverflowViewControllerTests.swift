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
    var sutDataProvider: TopicDataProvider!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "BrowseOverflowViewController") as? BrowseOverflowViewController
        sut.loadViewIfNeeded()
        sutDataProvider = TopicDataProvider()
        super.setUp()
    }

    override func tearDown() {
        sutDataProvider = nil
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

    func testDataSourceAndDelegateAreTheSame() {
        XCTAssertEqual(sut.tableView.dataSource as? TopicDataProvider, sut.tableView.delegate as? TopicDataProvider, "The data source and delegate shall be the same object.")
    }

    func testOneTableRowForOneTopicInDataProvider() {
        sutDataProvider.topics.append(Topic(name: "iPhone", tag: "iphone"))
        XCTAssertEqual(sutDataProvider.tableView(sut.tableView, numberOfRowsInSection: 0), 1, "The table view shall have the same number of rows as there are topics.")
    }

    func testTwoTableRowsForTwoTopicsInDataProvider() {
        sutDataProvider.topics.append(Topic(name: "iPhone", tag: "iphone"))
        sutDataProvider.topics.append(Topic(name: "macOS", tag: "macos"))
        XCTAssertEqual(sutDataProvider.tableView(sut.tableView, numberOfRowsInSection: 0), 2, "The table view shall have the same number of rows as there are topics.")
    }

    func testOnlyOneSectonInTheTableView() {
        XCTAssertEqual(sutDataProvider.numberOfSections(in: sut.tableView), 1, "There shall only be one section in the table view.")
    }
}
