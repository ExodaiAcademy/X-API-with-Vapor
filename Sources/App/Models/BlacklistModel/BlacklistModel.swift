//
//  File.swift
//  X-API-with-Vapor
//
//  Created by Johan Sas on 24/01/2025.
//

import Foundation
import Vapor
import Fluent

final class BlacklistModel: Model {
    static let schema: String = DatabaseSchemaEnum.blacklist.rawValue
    
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.userID)
    var userID: UserModel.IDValue
    
    @Field(key: FieldKeys.reason)
    var reason: String
    
    @Field(key: FieldKeys.blacklistedTill)
    var blacklistedTill: Date?
    
    @Field(key: FieldKeys.blacklistedUserID)
    var blacklistedUserID: UserModel.IDValue
    
    required init() {
        
    }
    
    init(id: UUID? = nil, userID: UserModel.IDValue, reason: String, blacklistedTill: Date? = nil, blacklistedUserID: UserModel.IDValue) {
        self.id = id
        self.userID = userID
        self.reason = reason
        self.blacklistedTill = blacklistedTill
        self.blacklistedUserID = blacklistedUserID
    }
    
    
}

extension BlacklistModel {
    struct FieldKeys {
        static var userID: FieldKey {"userID"}
        static var reason: FieldKey {"reason"}
        static var blacklistedTill: FieldKey {"blacklistedTill"}
        static var blacklistedUserID: FieldKey {"blacklistedUserID"}
    }
}

extension BlacklistModel {
    struct BlacklistModelMigration: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await database.schema(schema)
                .id()
                .field(FieldKeys.userID, .uuid, .required)
                .field(FieldKeys.reason, .string, .required)
                .field(FieldKeys.blacklistedTill, .datetime, .required)
                .field(FieldKeys.blacklistedUserID, .uuid, .required)
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(schema).delete()
        }
    }
}

extension BlacklistModel: BlacklistProtocol {}
