//
//  TweetDTO.swift
//  X
//
//  Created by Johan Sas on 17/01/2025.
//

import Vapor

struct CreateTweetDTO: Content {
    let content: String
    let publishDate: Date?
    //let status: StatusEnum.RawValue?
}

struct UpdateTweetDTO: Content {
    let publishDate: Date?
}
