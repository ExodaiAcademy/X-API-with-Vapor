//
//  CRUDProtocols.swift
//  X
//
//  Created by Johan Sas on 17/01/2025.
//

import Vapor
import Fluent

protocol CRUDProtocols {
    associatedtype createDTO
    associatedtype model
    associatedtype id
    associatedtype updateDTO
    
    static func createObject(_ req: Request, _ dto: createDTO) async throws -> HTTPStatus
    static func getObject(_ req: Request, _ id: id) async throws -> model
    static func getAllObjects(_ req: Request) async throws -> [model]
    static func updateObject(_ req: Request, id: id, dto: updateDTO) async throws -> HTTPStatus
    static func deleteObject(_ req: Request, id: id) async throws -> HTTPStatus
}
