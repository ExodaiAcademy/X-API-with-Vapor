//
//  BlacklistDTO.swift
//  X-API-with-Vapor
//
//  Created by Johan Sas on 27/01/2025.
//

import Vapor

struct CreateBlacklistDTO: Content {
    let userID: UserModel.IDValue
    let reason: String
    let blacklistedTill: Date
    let blacklistedUserID: UserModel.IDValue
}

struct UpdateBlacklistDTO: Content {
    let reason: String?
    let blacklistedTill: Date?
}
