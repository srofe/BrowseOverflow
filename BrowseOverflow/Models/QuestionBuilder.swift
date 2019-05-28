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
        var questionsToReturn: [Question] = []

        let jsonData = json.data(using: .utf8)
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData!) as? Dictionary<String,Any>, JSONSerialization.isValidJSONObject(jsonObject) else { throw QuestionBuilderError.invalidJson }

        if let questions = jsonObject["questions"] {
            for jsonQuestion in (questions as? [Dictionary<String,Any>])! {
                let question = questionFrom(json: jsonQuestion)
                questionsToReturn.append(question)
            }
            return questionsToReturn
        } else {
            throw QuestionBuilderError.missingData
        }
    }

    private func questionFrom(json: [String:Any]) -> Question {
        var question = Question()
        question.title = json["title"] as? String ?? ""

        return question
    }
}
