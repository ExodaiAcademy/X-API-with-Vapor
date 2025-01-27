//
//  RetweetDTO.swift
//  X-API-with-Vapor
//
//  Created by Johan Sas on 24/01/2025.
//

import Vapor

struct CreateRetweetDTO: Content {
    let tweetID: TweetModel.IDValue
    let content: String
    
}

struct UpdateRetweetDTO: Content {
    let content: String?
}
