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

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    private var posts: [Post] = []
    
    private init(fileName: String) {
        self.filename = fileName
        loadPosts()
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
    
    private func loadPosts() {
       guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: "json") else {
           fatalError("JSON file not found.")
       }

       guard let postData = try? Data(contentsOf: fileUrl) else {
           fatalError("Could not read the data.")
       }

       do {
           self.posts = try decoder.decode([Post].self, from: postData)
       } catch {
           fatalError("Failed to decode JSON: \(error)")
       }
   }

   func vote(for postId: String, optionId: String, increment: Bool) {
       guard let postIndex = posts.firstIndex(where: { $0.id == postId }) else {
               return
           }
       
       let optionIndex = posts[postIndex].options.firstIndex(where: { $0.id == optionId })
//           guard let optionIndex = posts[postIndex].options.firstIndex(where: { $0.id == optionId }) else {
//               return
//           }

           if optionIndex == 0 {
               posts[postIndex].votesForLeftImage += increment ? 1 : -1
           } else {
               posts[postIndex].votesForRightImage += increment ? 1 : -1
           }

           posts[postIndex].lastVoted = Date()
       
       savePosts()
   }

   private func savePosts() {
       guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: "json") else {
           fatalError("JSON file not found.")
       }

       do {
           let data = try encoder.encode(posts)
           try data.write(to: fileUrl)
       } catch {
           fatalError("Failed to encode JSON: \(error)")
       }
   }

}
