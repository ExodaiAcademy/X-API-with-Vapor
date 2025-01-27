//
//  BlacklistProtocol.swift
//  X-API-with-Vapor
//
//  Created by Johan Sas on 27/01/2025.
//

import Vapor
import Fluent

protocol BlacklistProtocol: MyTweetProtocol, HelperProtocols, CRUDProtocols where createDTO == CreateBlacklistDTO, updateDTO == UpdateBlacklistDTO, model == BlacklistModel, id == BlacklistModel.IDValue, userID == UserModel.IDValue {
    
}

extension BlacklistProtocol {
    static func createObject(_ req: Request, _ dto: createDTO) async throws -> HTTPStatus {
        guard let user = try req.auth.get(UserModel.self) else {
            throw Abort(.forbidden, reason: "You have to be logged In to be able to blacklist!")
        }
        guard let userID = user.id else {
            throw Abort(.notFound, reason: "No userID available")
        }
        let newBlacklistItem = BlacklistModel(userID: userID, reason: dto.reason, blacklistedUserID: dto.blacklistedUserID)
        try await newBlacklistItem.create(on: req.db)
        return .ok
        
    }
}

extension BlacklistProtocol {
    static func getObject(_ req: Request, _ id: id) async throws -> model {
        let blacklistItem = try await blackListItemExists(req, id)
        return blacklistItem
    }
}

extension BlacklistProtocol {
    static func getAllObjects(_ req: Request) async throws -> [model] {
        let blacklistItems = try await BlacklistModel.query(on: req.db)
            .all()
        return blacklistItems
    }
}

extension BlacklistProtocol {
    static func getMyObjectsbyID(_ req: Request, _ id: userID) async throws -> [model] {
        let blacklistItems = try await BlacklistModel.query(on: req.db)
            .filter(\.$userID == id)
            .all()
        return blacklistItems
    }
}

extension BlacklistProtocol {
    static func updateObject(_ req: Request, id: id, dto: updateDTO) async throws -> HTTPStatus {
        let blacklistItem = try await blackListItemExists(req, id)
        blacklistItem.userID = blacklistItem.userID
        blacklistItem.reason = dto.reason ?? blacklistItem.reason
        blacklistItem.blacklistedTill = dto.blacklistedTill ?? blacklistItem.blacklistedTill
        blacklistItem.blacklistedUserID = blacklistItem.blacklistedUserID
        try await blacklistItem.save(on: req.db)
        return .ok
    }
}

extension BlacklistProtocol {
    static func deleteObject(_ req: Request, _ id: id) async throws -> HTTPStatus {
        let blacklistItem = try await blackListItemExists(req, id)
        try await blacklistItem.delete(on: req.db)
        return .ok
    }
}
