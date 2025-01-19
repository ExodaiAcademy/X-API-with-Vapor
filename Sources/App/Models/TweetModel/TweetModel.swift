//
//  TweetModel.swift
//  X
//
//  Created by Johan Sas on 17/01/2025.
//

import Vapor
import Fluent

final class TweetModel: Model {
    static let schema: String = DatabaseSchemaEnum.tweets.rawValue
    
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.content)
    var content: String
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Field(key: FieldKeys.userID)
    var userID: UserModel.IDValue
    
    @OptionalField(key: FieldKeys.publishDate)
    var publishDate: Date?
    
    @Field(key: FieldKeys.status)
    var status: StatusEnum.RawValue
    
    required init() {}
    
    init(id: UUID? = nil, content: String, createdAt: Date? = nil, userID: UserModel.IDValue, publishDate: Date?, status: StatusEnum.RawValue) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.userID = userID
        self.publishDate = publishDate
        self.status = status
        
    }
    
}

extension TweetModel {
    struct FieldKeys {
        static var content: FieldKey {"content"}
        static var createdAt: FieldKey {"createdAt"}
        static var userID: FieldKey {"userID"}
        static var publishDate: FieldKey {"publishDate"}
        static var status: FieldKey {"status"}
    }
}

extension TweetModel: TweetProtocol {}
