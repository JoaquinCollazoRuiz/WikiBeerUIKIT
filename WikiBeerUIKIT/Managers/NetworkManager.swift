//
//  NetworkManager.swift
//  WikiBeerUIKIT
//
//  Created by Joaquin on 9/7/22.
//

import UIKit

struct NetworkManager {
    func load(_ imageURL: String, completion: @escaping (UIImage?) -> Void) {
        if let image = CacheManager.shared.getImage(for: imageURL) {
            completion(image)
            return
        }

        DispatchQueue.global().async {
            guard let url = URL(string: imageURL),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }

            CacheManager.shared.insert(image: image, for: imageURL)
            completion(image)
        }
    }

    func request<T: Decodable>(url: URL, completion: @escaping (T) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching beers: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            if let data = data, let result = try? decoder.decode(T.self, from: data) {
                completion(result)
            }
        })
        task.resume()
    }
}
