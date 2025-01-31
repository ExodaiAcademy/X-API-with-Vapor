//
//  File.swift
//  X-API-with-Vapor
//
//  Created by Johan Sas on 27/01/2025.
//

import Vapor
import Fluent

final class LikesModel: Model {
    static let schema: String = DatabaseSchemaEnum.followers.rawValue
    
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.userID)
    var userID: UserModel.IDValue
    
    @Field(key: FieldKeys.likedTweetID)
    var likedTweetID: UUID
    
    required init() {
        
    }
    
    init(id: UUID? = nil, userID: UserModel.IDValue, likedTweetID: UUID) {
        self.id = id
        self.userID = userID
        self.likedTweetID = likedTweetID
    }
}

extension LikesModel {
    struct FieldKeys {
        static var userID: FieldKey {"userID"}
        static var likedTweetID: FieldKey {"likedTweetID"}
    }
}

extension LikesModel {
    struct LikesModelMigration: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await database.schema(schema)
                .id()
                .field(FieldKeys.userID, .uuid, .required)
                .field(FieldKeys.likedTweetID, .uuid, .required)
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(schema).delete()
        }
    }
}

extension LikesModel: LikesProtocol {}
