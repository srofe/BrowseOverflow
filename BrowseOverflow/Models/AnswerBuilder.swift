//
//  AnswerBuilder.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 31/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

enum AnswerBuilderError : Error {
    case invalidJson
}

struct AnswerBuilder {
    func addAnswer(to question: Question, containing json: String) throws {
        throw AnswerBuilderError.invalidJson
    }
}
