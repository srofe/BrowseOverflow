//
//  BrowseOverflowViewController.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 21/6/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import UIKit

class BrowseOverflowViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataProvider: TopicDataProvider!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
    }
}
