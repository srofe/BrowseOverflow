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

    func testViewControllerHasTableViewProperty() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BrowseOverflowViewController") as! BrowseOverflowViewController
        controller.loadViewIfNeeded()
        XCTAssertNotNil(controller.tableView, "A BrowseOverflowViewController shall have a table view.")
    }

    func testViewControllerHasDataSourceProperty() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BrowseOverflowViewController") as! BrowseOverflowViewController
        controller.loadViewIfNeeded()
        XCTAssertTrue(controller.tableView.dataSource is TopicDataProvider, "The table view data source shall be a TopicDataProvider.")
    }
}
