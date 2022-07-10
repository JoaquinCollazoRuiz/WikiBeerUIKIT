//
//  BeerDetails.swift
//  WikiBeerUIKIT
//
//  Created by Joaquin on 9/7/22.
//

import Foundation

struct BeerDetails {
    let title: String
    let subtitle: String
    let details: String
    let imageURL: String
}

extension BeerDetails {

    static let mock = BeerDetails(title: "mockTitle",
                                  subtitle: "mockSubtitle",
                                  details: "mockDetails",
                                  imageURL: "mockImageURL")
}
