//
//  File.swift
//  X-API-with-Vapor
//
//  Created by Johan Sas on 27/01/2025.
//

import Foundation
import Fluent
import Vapor

final class BlockedModel: Model {
    static let schema: String = DatabaseSchemaEnum.blocked.rawValue
    
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.userID)
    var userID: UserModel.IDValue
    
    @Field(key: FieldKeys.blockedUserID)
    var blockedUserID: UserModel.IDValue
    
    required init() {
        
    }
    
    init(id: UUID? = nil, userID: UserModel.IDValue, blockedUserID: UserModel.IDValue) {
        self.id = id
        self.userID = userID
        self.blockedUserID = blockedUserID
    }
}

extension BlockedModel {
    struct FieldKeys {
        static var userID: FieldKey {"userID"}
        static var blockedUserID: FieldKey {"blockedUserID"}
    }
}

extension BlockedModel: BlockedProtocol {}
