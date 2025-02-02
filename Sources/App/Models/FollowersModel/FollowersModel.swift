//
//  File.swift
//  X-API-with-Vapor
//
//  Created by Johan Sas on 27/01/2025.
//

import Foundation
import Vapor
import Fluent

final class FollowersModel: Model {
    static let schema: String = DatabaseSchemaEnum.followers.rawValue
    
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.userID)
    var userID: UserModel.IDValue
    
    @Field(key: FieldKeys.followUserID)
    var followUserID: UserModel.IDValue
    
    required init() {
        
    }
    
    init(id: UUID? = nil, userID: UserModel.IDValue, followUserID: UserModel.IDValue) {
        self.id = id
        self.userID = userID
        self.followUserID = followUserID
    }
}

extension FollowersModel {
    struct FieldKeys {
        static var userID: FieldKey {"userID"}
        static var followUserID: FieldKey {"followUserID"}
    }
}

extension FollowersModel {
    struct FollowersModelMigration: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await database.schema(schema)
                .id()
                .field(FieldKeys.userID, .uuid, .required)
                .field(FieldKeys.followUserID, .uuid, .required)
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(schema).delete()
        }
    }
}

extension FollowersModel: FollowersProtocol {}
