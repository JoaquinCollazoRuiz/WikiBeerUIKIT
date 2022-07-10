//
//  CacheManager.swift
//  WikiBeerUIKIT
//
//  Created by Joaquin on 9/7/22.
//

import UIKit

struct CacheManager {

    static let shared = CacheManager()

    private var images = NSCache<NSString, UIImage>()

    func insert(image: UIImage, for url: String) {
        images.setObject(image, forKey: url as NSString)
    }

    func getImage(for url: String) -> UIImage? {
        images.object(forKey: url as NSString)
    }
}
