//
//  PostViewModel.swift
//  PollTableView
//
//  Created by Aslıhan Gürkan on 20.05.2024.
//

import UIKit

struct PostViewModel {
    let post: Post

    var id: String {
        return post.id
    }

    var createdAt: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, h:mm a"
        return formatter.string(from: post.createdAt)
    }
    
    var createdDate: Date {
        return post.createdAt
    }

    var content: String {
        return post.content
    }

    var userImage: UIImage {
        return post.user.image
    }
    
    var votesForLeftImage: Int {
        return post.votesForLeftImage
    }
    
    var votesForRightImage: Int {
        return post.votesForRightImage
    }
    
    var lastVotedAt: Date {
        return post.lastVoted
    }
    
    var username: String {
        return post.user.username
    }

    var options: [OptionViewModel] {
        return post.options.map { OptionViewModel(option: $0) }
    }
}



