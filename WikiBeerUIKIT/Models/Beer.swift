//
//  Beer.swift
//  WikiBeerUIKIT
//
//  Created by Joaquin on 9/7/22.
//

import Foundation

struct Beer: Codable {
    let name: String
    let tagline: String
    let description: String
    let imageURL: String
}

extension Beer {
    enum CodingKeys: String, CodingKey {
        case name, tagline, description
        case imageURL = "imageUrl"
    }
}
