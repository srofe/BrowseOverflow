//
//  QuestionBuilder.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 28/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

protocol QuestionBuilderProtocol {
    func questionsFrom(json: String) throws -> [Question]?
}

struct QuestionBuilder : QuestionBuilderProtocol {
    func questionsFrom(json: String) throws -> [Question]? {
        return nil
    }
}
