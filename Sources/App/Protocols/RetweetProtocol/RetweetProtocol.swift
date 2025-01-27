//
//  File.swift
//  X-API-with-Vapor
//
//  Created by Johan Sas on 24/01/2025.
//

import Foundation
import Vapor
import Fluent

protocol RetweetProtocol: HelperProtocols, MyTweetProtocol, CRUDProtocols where createDTO == CreateReTweetDTO, updateDTO == UpdateReTweetDTO, model == RetweetModel, id == RetweetModel.IDValue, userID == UserModel.IDValue {
    
}

extension RetweetProtocol {
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
            
            let newRetweet = RetweetModel(tweetID: dto.tweetID, content: dto.content, userID: userID)
            
            try await newRetweet.create(on: req.db)
            return .ok
        }
    }
}

extension RetweetProtocol {
    static func getObject(_ req: Request, _ id: id) async throws -> model {
        guard let retweet = try await RetweetModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "RetweetModel with id of \(id) could not be found")
        }
        return retweet
    }
}

extension RetweetProtocol {
    static func getAllObjects(_ req: Request) async throws -> [model] {
        let retweets = try await RetweetModel.query(on: req.db)
            .all
        return retweets
    }
}

extension RetweetProtocol {
    static func getMyObjectsbyID(_ req: Request, _ id: userID) async throws -> [model] {
        let retweets = try await RetweetModel.query(on: req.db)
            .filter(\.$userID == id)
            .all()
        return retweets
    }
}

extension RetweetProtocol {
    static func updateObject(_ req: Request, id: id, dto: updateDTO) async throws -> HTTPStatus {
        let retweet = try await retweetDoesExist(req, id)
        retweet.content = dto.content ?? retweet.content
        
        try await retweet.save(on: req.db)
        return .ok
    }
}

extension RetweetProtocol {
    static func deleteObject(_ req: Request, id: id) async throws -> HTTPStatus {
        let retweet = try await retweetDoesExist(req, id)

        try await retweet.delete(on: req.db)
        return .ok
    }
}
