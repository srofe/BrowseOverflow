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
        guard let jsonData = json.data(using: .utf8) else { throw AnswerBuilderError.invalidJson }
        guard let queryDictionary = try? JSONSerialization.jsonObject(with: jsonData), JSONSerialization.isValidJSONObject(queryDictionary) else { throw AnswerBuilderError.invalidJson }
    }
}
