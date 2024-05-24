//
//  Post.swift
//  Pollexa
//
//  Created by Emirhan Erdogan on 13/05/2024.
//

import UIKit

struct Post: Decodable {
    
    let id: String
    let createdAt: Date
    let content: String
    let options: [Option]
    var votesForLeftImage: Int
    var votesForRightImage: Int
    var lastVoted: Date
    let user: User

}

