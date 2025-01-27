//
//  HelperProtocols.swift
//  X
//
//  Created by Johan Sas on 17/01/2025.
//

import Vapor
import Fluent

protocol HelperProtocols {
    static func checkIfUserExists(_ req: Request, _ id: UserModel.IDValue) async throws -> UserModel
    static func doesUserWithEmailExists(_ req: Request, _ email: String) async throws -> Bool
    static func tweetDoesExist(_ req: Request, _ id: TweetModel.IDValue) async throws -> TweetModel
    static func getLoggedInUser(_ req: Request) async throws -> UserModel
    static func blackListItemExists(_ req: Request, _ id: BlacklistModel.IDValue) async throws -> BlacklistModel
}

extension HelperProtocols {
    static func checkIfUserExists(_ req: Request, _ id: UserModel.IDValue) async throws -> UserModel {
        guard let user = try await UserModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "User with the ID of \(id) does not exist")
        }
        return user
    }
}

extension HelperProtocols {
    static func getLoggedInUser(_ req: Request) async throws -> UserModel {
        guard let user = req.auth.get(UserModel.self) else {
            throw Abort(.forbidden, reason: "You have to be logged In to be able to blacklist!")
        }
        return user
    }
}

extension HelperProtocols {
    static func doesUserWithEmailExists(_ req: Request, _ email: String) async throws -> Bool {
        guard let users = try await UserModel.query(on: req.db)
            .filter(\.$email == email)
            .first() else {
            return false
        }
        return true
    }
}

extension HelperProtocols {
    static func tweetDoesExist(_ req: Request, _ id: TweetModel.IDValue) async throws -> TweetModel {
        guard let tweet = try await TweetModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Tweet with id of \(id) does not exist")
        }
        return tweet
    }
}

extension HelperProtocols {
    static func retweetDoesExist(_ req: Request, _ id: RetweetModel.IDValue) async throws -> RetweetModel {
        guard let retweet = try await RetweetModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "ReTweet with id of \(id) does not exist")
        }
        return retweet
    }
}

extension HelperProtocols {
    static func blackListItemExists(_ req: Request, _ id: BlacklistModel.IDValue) async throws -> BlacklistModel{
        guard let blacklistItem = try await BlacklistModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "There is no BlacklistModel with the id of \(id)")
        }
        return blacklistItem
    }
}
