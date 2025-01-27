//
//  MyTweetProtocol.swift
//  X
//
//  Created by Johan Sas on 17/01/2025.
//

import Vapor
import Fluent

protocol MyTweetProtocol {
    associatedtype model
    associatedtype userID
    
    static func getMyObjectsbyID(_ req: Request, _ id: userID) async throws -> [model]
}
