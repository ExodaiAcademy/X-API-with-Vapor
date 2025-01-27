//
//  TweetProtocol.swift
//  X
//
//  Created by Johan Sas on 17/01/2025.
//

import Vapor
import Fluent

protocol TweetProtocol: HelperProtocols, MyTweetProtocol, CRUDProtocols where createDTO == CreateTweetDTO, updateDTO == UpdateTweetDTO, model == TweetModel, id == TweetModel.IDValue, userID == UserModel.IDValue {
    
}

extension TweetProtocol {
    static func createObject(_ req: Request, _ dto: createDTO) async throws -> HTTPStatus {
        let user = try req.auth.require(UserModel.self)
        let status: StatusEnum.RawValue
        guard let userID = user.id else {
            throw Abort(.forbidden, reason: "You are not allowed to proceed")
        }
        if dto.content.count == 200 {
            throw Abort(.internalServerError, reason: "The tweet is to long")
        } else {
            if dto.publishDate != nil {
                status = StatusEnum.planned.rawValue
            } else {
                status = StatusEnum.published.rawValue
            }
            
            let newTweet = TweetModel(content: dto.content, userID: userID, publishDate: dto.publishDate, status: status)
            try await newTweet.create(on: req.db)
            return .ok
        }
    }
}

extension TweetProtocol {
    static func getObject(_ req: Request, _ id: id) async throws -> model {
        guard let tweet = try await TweetModel.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$status == StatusEnum.published.rawValue)
            .first() else {
            throw Abort(.notFound, reason: "Tweet with id of \(id) does not exist or is not published yet.")
        }
        return tweet
    }
}

extension TweetProtocol {
    static func getAllObjects(_ req: Request) async throws -> [model] {
        let tweets = try await TweetModel.query(on: req.db)
            .filter(\.$status == StatusEnum.published.rawValue)
            .all()
        return tweets
    }
}

extension TweetProtocol {
    static func getMyObjectsbyID(_ req: Request, _ id: userID) async throws -> [model] {
        let tweets = try await TweetModel.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$status == StatusEnum.published.rawValue)
            .all()
        return tweets
    }
}

extension TweetProtocol {
    static func updateObject(_ req: Request, id: id, dto: updateDTO) async throws -> HTTPStatus {
        let tweet = try await tweetDoesExist(req, id)
        tweet.publishDate = dto.publishDate ?? tweet.publishDate
        try await tweet.save(on: req.db)
        return .ok
    }
}

extension TweetProtocol {
    static func deleteObject(_ req: Request, id: id) async throws -> HTTPStatus {
        let tweet = try await tweetDoesExist(req, id)

        try await tweet.delete(on: req.db)
        return .ok
    }
}
