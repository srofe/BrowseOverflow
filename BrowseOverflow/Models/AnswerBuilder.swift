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

protocol AnswerBuilderProtocol {
    func addAnswer(to question: inout Question, containing json: String) throws
}

struct AnswerBuilder : AnswerBuilderProtocol {
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
        answer.accepted = answerDictionary["is_accepted"] as? Bool ?? false
        answer.score = answerDictionary["score"] as? Int ?? 0
        if let ownerDictionary = answerDictionary["owner"] as? Dictionary<String,Any> {
            answer.person = PersonBuilder.personFrom(userDictionary: ownerDictionary)
        }
        return answer
    }
}
