//
//  TopicDataProvider.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 21/6/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import UIKit

class TopicDataProvider: NSObject {

    var topics: [Topic] = []
}

extension TopicDataProvider: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension TopicDataProvider: UITableViewDelegate {
}
