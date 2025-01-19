//
//  UserDTO.swift
//  X
//
//  Created by Johan Sas on 17/01/2025.
//

import Vapor

struct CreateUserDTO: Content {
    let username: String
    let email: String
    let password: String
}

struct UpdateUserDTO: Content {
    let username: String?
    let email: String?
    let bio: String?
}

struct UpdatePasswordDTO: Content {
    let password: String
    let verify: String
}
