//
//  AnswerBuilder.swift
//  BrowseOverflow
//
//  Created by Simon Rofe on 31/5/19.
//  Copyright © 2019 Simon Rofe. All rights reserved.
//

import Foundation

enum AnswerBuilderError : Error {
    case dataEncoding
    case invalidJson
    case missionData
}

struct AnswerBuilder {
    func addAnswer(to question: Question, containing json: String) throws {
        guard let jsonData = json.data(using: .utf8) else { throw AnswerBuilderError.dataEncoding }
        guard let queryDictionary = try? JSONSerialization.jsonObject(with: jsonData) as? Dictionary<String,Any>, JSONSerialization.isValidJSONObject(queryDictionary) else { throw AnswerBuilderError.invalidJson }
        if let _ = queryDictionary["items"] {
        } else {
            throw AnswerBuilderError.missionData
        }
    }
}
