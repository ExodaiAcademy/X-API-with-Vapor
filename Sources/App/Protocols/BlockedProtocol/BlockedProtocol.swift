//
//  BlockedProtocol.swift
//  X-API-with-Vapor
//
//  Created by Johan Sas on 27/01/2025.
//

import Vapor
import Fluent

protocol BlockedProtocol: HelperProtocols {
    static func addToBlockList(_ req: Request, id: UserModel.IDValue) async throws -> HTTPStatus
    static func deleteFromBlockList(_ req: Request, id: UserModel.IDValue) async throws -> HTTPStatus
}

extension BlockedProtocol {
    static func addToBlockList(_ req: Request, id: UserModel.IDValue) async throws -> HTTPStatus {
        let user = try await getLoggedInUser(req)
        
        guard let userID = user.id else {
            throw Abort(.notFound, reason: "No id found on User")
        }
        let newBlock = BlockedModel(userID: userID , blockedUserID: id)
        try await newBlock.create(on: req.db)
        return .ok
    }
}

extension BlockedProtocol {
    static func deleteFromBlockList(_ req: Request, id: UserModel.IDValue) async throws -> HTTPStatus {
        let user = try await getLoggedInUser(req)
        
        guard let userID = user.id else {
            throw Abort(.notFound, reason: "No id found on User")
        }
        
        guard let block = try await BlockedModel.query(on: req.db)
            .filter(\.$userID == userID)
            .filter(\.$blockedUserID == id)
            .first() else {
            throw Abort(.notFound, reason: "No blocks found")
        }
        
        try await block.delete(on: req.db)
        return .ok
    }
}
