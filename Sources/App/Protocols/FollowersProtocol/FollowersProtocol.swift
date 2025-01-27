//
//  File.swift
//  X
//
//  Created by Johan Sas on 27/01/2025.
//

import Foundation
import Vapor
import Fluent

protocol FollowersProtocol: HelperProtocols {
    static func addFollow(_ req: Request, id: UserModel.IDValue) async throws -> HTTPStatus
    static func unFollow(_ req: Request, id: UserModel.IDValue) async throws -> HTTPStatus
}


extension FollowersProtocol {
    static func addFollow(_ req: Request, id: UserModel.IDValue) async throws -> HTTPStatus {
        let user = try await getLoggedInUser(req)
        
        guard let userID = user.id else {
            throw Abort(.notFound, reason: "No ID Found")
        }
        let newFollow = FollowersModel(userID: userID, followUserID: id)
        try await newFollow.create(on: req.db)
        return .ok
        
    }
}

extension FollowersProtocol {
    static func unFollow(_ req: Request, id: UserModel.IDValue) async throws -> HTTPStatus {
        let user = try await getLoggedInUser(req)
        
        guard let userID = user.id else {
            throw Abort(.notFound, reason: "No ID Found")
        }
        
        guard let follow = try await FollowersModel.query(on: req.db)
            .filter(\.$userID == userID)
            .filter(\.$followUserID == id)
            .first() else {
            throw Abort(.notFound, reason: "No follow found")
        }
        
        try await follow.delete(on: req.db)
        return .ok
    }
}
