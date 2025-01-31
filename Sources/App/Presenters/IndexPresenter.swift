//
//  File.swift
//  X
//
//  Created by Johan Sas on 31/01/2025.
//

import Foundation
import Leaf
import Vapor

struct IndexPresenter {
    @Sendable func presentPage(_ req: Request) async throws -> View {
        let context = IndexContext(title: "Vapor X | Dashboard")
        return try await req.view.render("dashboard", context)
    }
}
