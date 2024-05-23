//
//  PostProvider.swift
//  Pollexa
//
//  Created by Aslıhan Gürkan on 20/05/2024.
//

import UIKit

class PostProvider {
    static let shared = PostProvider(fileName: "posts")
    private let filename: String

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    private init(fileName: String) {
        self.filename = fileName
    }

    func fetchAll(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: "json") else {
            completion(.failure(NSError(domain: "JSON file not found.", code: 0)))
            return
        }

        guard let postData = try? Data(contentsOf: fileUrl) else {
            completion(.failure(NSError(domain: "Could not read the data.", code: 1)))
            return
        }

        do {
            let posts = try decoder.decode([Post].self, from: postData)
            completion(.success(posts))
        } catch {
            completion(.failure(error))
        }
    }
    
}
