//
//  QuestionBuilder.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 28/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

enum QuestionBuilderError : Error {
    case invalidJson
    case missingData
}

protocol QuestionBuilderProtocol {
    func questionsFrom(json: String) throws -> [Question]?
}

struct QuestionBuilder : QuestionBuilderProtocol {
    func questionsFrom(json: String) throws -> [Question]? {
        let jsonData = json.data(using: .utf8)
        if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData!) as? Dictionary<String,Any>, JSONSerialization.isValidJSONObject(jsonObject) {
            if let _ = jsonObject["questions"] {
            } else {
                throw QuestionBuilderError.missingData
            }
        }
        throw QuestionBuilderError.invalidJson
    }
}
