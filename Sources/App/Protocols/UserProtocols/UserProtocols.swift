//
//  UserProtocols.swift
//  X
//
//  Created by Johan Sas on 17/01/2025.
//

import Vapor
import Fluent

protocol UserProtocols: HelperProtocols, CRUDProtocols where createDTO == CreateUserDTO, updateDTO == UpdateUserDTO, model == UserModel.Public, id == UserModel.IDValue {
}

extension UserProtocols {
    static func createObject(_ req: Request, _ dto: createDTO) async throws -> HTTPStatus {
        let checkUser = try await doesUserWithEmailExists(req, dto.email)
        if checkUser != true {
            throw Abort(.internalServerError, reason: "User with email of \(dto.email) does already exist")
        } else {
            let newUser = UserModel(username: dto.username, password: dto.password, email: dto.email, role: RoleEnum.user.rawValue)
            try await newUser.create(on: req.db)
        }
        return .ok
    }
}

extension UserProtocols {
    static func getObject(_ req: Request, _ id: id) async throws -> model {
        let user = try await checkIfUserExists(req, id)
        return user.convertToPublic()
    }
}

extension UserProtocols {
    static func getAllObjects(_ req: Request) async throws -> [model] {
        return try await UserModel.query(on: req.db)
            .all()
            .convertToPublic()
    }
}

extension UserProtocols {
    static func updateObject(_ req: Request, id: id, dto: updateDTO) async throws -> HTTPStatus {
        let user = try await checkIfUserExists(req, id)
        user.username = dto.username ?? user.username
        user.email = dto.email ?? user.email
        user.bio = dto.bio ?? user.bio
        try await user.save(on: req.db)
        return .ok
    }
}

extension UserProtocols {
    static func deleteObject(_ req: Request, id: id) async throws -> HTTPStatus {
        let user = try await checkIfUserExists(req, id)
        try await user.delete(on: req.db)
        return .ok
    }
}
