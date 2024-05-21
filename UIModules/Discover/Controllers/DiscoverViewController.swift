//
//  ViewController.swift
//  PollexaTest1
//
//  Created by Aslıhan Gürkan on 20.05.2024.
//

import UIKit

class DiscoverViewController: UIViewController {

    // MARK: - Properties
    private let postProvider = PostProvider.shared
    private var postViewModels = [PostViewModel]()

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var activePollsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupViews()
        setupConstraints()
        fetchPosts()

    }


    private func setupViews() {
        
    }

    private func setupConstraints() {

        activePollsButton.layer.cornerRadius = activePollsButton.frame.height / 2
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    
    private func fetchPosts() {
        postProvider.fetchAll { [weak self] result in
            switch result {
            case .success(let posts):
                self?.postViewModels = posts.map { PostViewModel(post: $0) }
                self?.tableView.reloadData()
                self?.updateActivePolls()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func updateActivePolls() {
        // Henüz oylanmamış anketlerin sayısını hesapla
        let activePollsCount = postViewModels.count
        activePollsButton.setTitle("\(activePollsCount) Active Polls", for: .normal)
    }
    
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postViewModels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        let postViewModel = postViewModels[indexPath.row]
        cell.configure(with: postViewModel)
       
        //setupCellViews()
        cell.layer.borderWidth = 10
        cell.layer.cornerRadius = 35
        
        return cell
        
    }
    
    private func setupCellViews() {
        
    }
}
