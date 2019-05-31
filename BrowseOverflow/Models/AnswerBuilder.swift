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
    func addAnswer(to question: inout Question, containing json: String) throws {
        guard let jsonData = json.data(using: .utf8) else { throw AnswerBuilderError.dataEncoding }
        guard let queryDictionary = try? JSONSerialization.jsonObject(with: jsonData) as? Dictionary<String,Any>, JSONSerialization.isValidJSONObject(queryDictionary) else { throw AnswerBuilderError.invalidJson }
        if let answers = queryDictionary["items"] {
            for answerDictionary in (answers as? [Dictionary<String,Any>])! {
                let answer = answerFrom(answerDictionary: answerDictionary)
                question.add(answer: answer)
            }
        } else {
            throw AnswerBuilderError.missionData
        }
    }

    private func answerFrom(answerDictionary: [String:Any]) -> Answer {
        var answer = Answer()
        answer.text = answerDictionary["body"] as? String ?? ""
        return answer
    }
}
