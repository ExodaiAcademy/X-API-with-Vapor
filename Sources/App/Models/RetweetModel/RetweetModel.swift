//
//  File.swift
//  X-API-with-Vapor
//
//  Created by Johan Sas on 24/01/2025.
//

import Foundation
import Vapor
import Fluent

final class RetweetModel: Model {
    static let schema: String = DatabaseSchemaEnum.retweets.rawValue
    
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.tweetID)
    var tweetID: TweetModel.IDValue
    
    @OptionalField(key: FieldKeys.content)
    var content: String?
    
    @Field(key: FieldKeys.userID)
    var userID: UserModel.IDValue
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    required init() {
        
    }
    
    init(id: UUID? = nil, tweetID: TweetModel.IDValue, content: String?, userID: UserModel.IDValue, createdAt: Date? = nil) {
        self.id = id
        self.tweetID = tweetID
        self.content = content
        self.userID = userID
        self.createdAt = createdAt
    }
    
}

extension RetweetModel {
    struct FieldKeys {
        static var tweetID: FieldKey {"tweetID"}
        static var content: FieldKey {"content"}
        static var userID: FieldKey {"userID"}
        static var createdAt: FieldKey {"createdAt"}
    }
}

extension RetweetModel {
    struct RetweetModelMigration: AsyncMigration {
        func prepare(on database: any Database) async throws {
            try await database.schema(schema)
                .id()
                .field(FieldKeys.tweetID, .uuid, .required)
                .field(FieldKeys.content, .string)
                .field(FieldKeys.userID, .uuid, .required)
                .field(FieldKeys.createdAt, .datetime)
                .create()
                
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(schema).delete()
        }
    }
}

extension RetweetModel: RetweetProtocol {}
