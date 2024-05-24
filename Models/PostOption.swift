//
//  PostOption.swift
//  Pollexa
//
//  Created by Emirhan Erdogan on 13/05/2024.
//

import UIKit

extension Post {
    
    struct Option: Codable {
        
        // MARK: - Types
        enum CodingKeys: String, CodingKey {
            case id
            case imageName
        }
        
        // MARK: - Properties
        let id: String
        let image: UIImage
        
        // MARK: - Life Cycle
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            id = try container.decode(String.self, forKey: .id)
            
            let imageName = try container.decode(
                String.self,
                forKey: .imageName
            )
            
            if let image = UIImage(named: imageName) {
                self.image = image
            } else {
                throw DecodingError.dataCorrupted(.init(
                    codingPath: [CodingKeys.imageName],
                    debugDescription: "An image with name \(imageName) could not be loaded from the bundle.")
                )
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(id, forKey: .id)
            
            let imageName = (image.accessibilityIdentifier ?? "") // or however you are storing image name
            try container.encode(imageName, forKey: .imageName)
        }
    }
}
