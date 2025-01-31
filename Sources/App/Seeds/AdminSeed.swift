//
//  AdminSeed.swift
//  X
//
//  Created by Johan Sas on 31/01/2025.
//

import Fluent
import Vapor


struct AdminSeed: AsyncMigration {
    func prepare(on database: Database) async throws {
        let newAdminUser = UserModel(username: "Johan", password: try Bcrypt.hash("Test123456"), email: "johan@test.com", role: RoleEnum.admin.rawValue)
        
        print("Creating new Admin")
        
        try await newAdminUser.create(on: database)
    }
    
    func revert(on database: Database) async throws {
        let schema = UserModel.schema.self
        
        try await database.schema(schema).delete()
    }
    
}
