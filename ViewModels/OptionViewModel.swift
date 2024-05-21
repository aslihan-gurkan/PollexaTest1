//
//  OptionViewModel.swift
//  PollTableView
//
//  Created by Aslıhan Gürkan on 20.05.2024.
//

import UIKit

struct OptionViewModel {
    
    let option: Post.Option

    var id: String {
        return option.id
    }

    var image: UIImage {
        return option.image
    }
}
