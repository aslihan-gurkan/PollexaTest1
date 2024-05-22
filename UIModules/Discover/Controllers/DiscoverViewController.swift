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
        fetchPosts()
    }

    private func setupViews() {
        activePollsButton.layer.cornerRadius = 20//activePollsButton.frame.height / 2
        activePollsButton.tintColor = UIColor.systemGroupedBackground
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
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return postViewModels.count
//    }
    
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
//        cell.layer.borderColor = UIColor.red.cgColor //UIColor.white.cgColor
//        cell.layer.borderWidth = 10
//        cell.layer.cornerRadius = 35
//        cell.layer.cornerRadius /cell.layer.cornerRadius / 2
        cell.layer.borderWidth = 10
        cell.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        
        cell.layer.cornerRadius = 35
        
        return cell
        
    }
    
    private func setupCellViews() {
        
    }
}
