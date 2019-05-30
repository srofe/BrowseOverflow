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
    func questions(from json: String) throws -> [Question]?
    func questionBody(for question: inout Question, from json: String)
}

struct QuestionBuilder : QuestionBuilderProtocol {

    func questions(from json: String) throws -> [Question]? {
        var questionsToReturn: [Question] = []

        let jsonData = json.data(using: .utf8)
        guard let queryDictionary = try? JSONSerialization.jsonObject(with: jsonData!) as? Dictionary<String,Any>, JSONSerialization.isValidJSONObject(queryDictionary) else { throw QuestionBuilderError.invalidJson }

        if let questions = queryDictionary["questions"] {
            for questionDictionary in (questions as? [Dictionary<String,Any>])! {
                let question = questionFrom(questionDictionary: questionDictionary)
                questionsToReturn.append(question)
            }
            return questionsToReturn
        } else {
            throw QuestionBuilderError.missingData
        }
    }

    func questionBody(for question: inout Question, from json: String) {
        let jsonData = json.data(using: .utf8)
        guard let queryDictionary = try? JSONSerialization.jsonObject(with: jsonData!) as? Dictionary<String,Any>, JSONSerialization.isValidJSONObject(queryDictionary) else { return }
        if let questions = queryDictionary["questions"] as? [Dictionary<String,Any>] {
            let body = questions.last?["body"] as? String
            question.body = body
        }
    }

    private func questionFrom(questionDictionary: [String:Any]) -> Question {
        var question = Question()
        question.id = questionDictionary["question_id"] as? Int ?? 0
        let timeIntervalSince1970 = questionDictionary["creation_date"] as? Double ?? 0
        question.date = Date(timeIntervalSince1970: timeIntervalSince1970)
        question.score = questionDictionary["score"] as? Int ?? 0
        question.title = questionDictionary["title"] as? String ?? ""
        if let ownerDictionary = questionDictionary["owner"] as? Dictionary<String,Any> {
            question.asker = PersonBuilder.personFrom(userDictionary: ownerDictionary)
        }

        return question
    }
}
