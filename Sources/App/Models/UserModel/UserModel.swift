//
//  UserModel.swift
//  X
//
//  Created by Johan Sas on 17/01/2025.
//

import Fluent
import Vapor

final class UserModel: Model {
    static let schema: String = DatabaseSchemaEnum.users.rawValue
    
    @ID()
    var id: UUID?
    
    @Field(key: FieldKeys.username)
    var username: String
    
    @Field(key: FieldKeys.password)
    var password: String
        
    @Field(key: FieldKeys.email)
    var email: String
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    @OptionalField(key: FieldKeys.bio)
    var bio: String?
    
    @OptionalField(key: FieldKeys.profileImage)
    var profileImage: URL?
    
    @OptionalField(key: FieldKeys.headerImage)
    var headerImage: URL?
    
    @Field(key: FieldKeys.role)
    var role: RoleEnum.RawValue
    
    required init() {
        
    }
    
    init(id: UUID? = nil, username: String, password: String, email: String, createdAt: Date? = nil, updatedAt: Date? = nil, bio: String? = nil, profileImage: URL? = nil, headerImage: URL? = nil, role: RoleEnum.RawValue) {
        self.id = id
        self.username = username
        self.password = password
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.bio = bio
        self.profileImage = profileImage
        self.headerImage = headerImage
        self.role = role
    }
    
    
    final class Public: Model {
        static let schema: String = DatabaseSchemaEnum.users.rawValue
        
        @ID()
        var id: UUID?
        
        @Field(key: FieldKeys.username)
        var username: String
        
        @Field(key: FieldKeys.email)
        var email: String
        
        @Timestamp(key: FieldKeys.createdAt, on: .create)
        var createdAt: Date?
        
        @Timestamp(key: FieldKeys.updatedAt, on: .update)
        var updatedAt: Date?
        
        @OptionalField(key: FieldKeys.bio)
        var bio: String?
        
        @OptionalField(key: FieldKeys.profileImage)
        var profileImage: URL?
        
        @OptionalField(key: FieldKeys.headerImage)
        var headerImage: URL?
        
        
        
        required init() {
            
        }
        
        init(id: UUID? = nil, username: String, email: String, createdAt: Date?, updatedAt: Date?, bio: String?, profileImage: URL?, headerImage: URL?) {
            self.id = id
            self.username = username
            self.email = email
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.bio = bio
            self.profileImage = profileImage
            self.headerImage = headerImage
        }
    }
    
}

extension UserModel {
    struct FieldKeys {
        static var username: FieldKey {"username"}
        static var password: FieldKey {"password"}
        static var email: FieldKey {"email"}
        static var createdAt: FieldKey {"createdAt"}
        static var updatedAt: FieldKey {"updatedAt"}
        static var bio: FieldKey {"bio"}
        static var profileImage: FieldKey {"profileImage"}
        static var headerImage: FieldKey {"headerImage"}
        static var role: FieldKey {"role"}
    }
}

extension UserModel {
    struct UserModelMigration: AsyncMigration {
        func revert(on database: any FluentKit.Database) async throws {
            try await database.schema(schema).delete()
        }
        
        func prepare(on database: any FluentKit.Database) async throws {
            try await database.schema(schema)
                .id()
                .field(FieldKeys.username, .string, .required)
                .field(FieldKeys.password, .string, .required)
                .field(FieldKeys.email, .string, .required)
                .field(FieldKeys.createdAt, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .field(FieldKeys.bio, .string)
                .field(FieldKeys.profileImage, .string)
                .field(FieldKeys.headerImage, .string)
                .field(FieldKeys.role, .string, .required)
                .unique(on: FieldKeys.username)
                .unique(on: FieldKeys.email)
                .create()
        }
    }
}


extension UserModel {
    func convertToPublic() -> UserModel.Public {
        return UserModel.Public(username: username, email: email, createdAt: createdAt, updatedAt: updatedAt, bio: bio, profileImage: profileImage, headerImage: headerImage)
    }
}

extension Collection where Element: UserModel {
    func convertToPublic() -> [UserModel.Public] {
        return self.map {
            $0.convertToPublic()
        }
    }
}

extension UserModel: Authenticatable {}

extension UserModel: UserProtocols {}
