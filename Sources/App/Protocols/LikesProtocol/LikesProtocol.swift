//
//  LikesProtocol.swift
//  X
//
//  Created by Johan Sas on 27/01/2025.
//

import Vapor
import Fluent

protocol LikesProtocol: HelperProtocols {
    static func like(_ req: Request, _ id: UUID) async throws -> HTTPStatus
    static func unLike(_ req: Request, _ id: UUID) async throws -> HTTPStatus
}

extension LikesProtocol {
    static func like(_ req: Request, _ id: UUID) async throws -> HTTPStatus {
        let user = try await getLoggedInUser(req)
        
        guard let userID = user.id else {
            throw Abort(.notFound, reason: "No ID Found")
        }
        
        let newLike = LikesModel(userID: userID, likedTweetID: id)
        try await newLike.create(on: req.db)
        return .ok
    }
}

extension LikesProtocol {
    static func unLike(_ req: Request, _ id: UUID) async throws -> HTTPStatus {
        let user = try await getLoggedInUser(req)
        
        guard let userID = user.id else {
            throw Abort(.notFound, reason: "No ID Found")
        }
        
        guard let like = try await LikesModel.query(on: req.db)
            .filter(\.$userID == userID)
            .filter(\.$likedTweetID == id)
            .first() else {
            throw Abort(.notFound, reason: "No Like Found")
        }
        try await like.delete(on: req.db)
        return .ok
    }
}
