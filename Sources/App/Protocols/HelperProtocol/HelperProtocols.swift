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
