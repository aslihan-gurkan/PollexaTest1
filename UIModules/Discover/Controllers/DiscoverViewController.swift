//
//  ViewController.swift
//  PollexaTest1
//
//  Created by Aslıhan Gürkan on 20.05.2024.
//

import UIKit

class DiscoverViewController: UIViewController {

    // MARK: - Properties
    let postProvider = PostProvider.shared
    private var postViewModels = [PostViewModel]()

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var activePollsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait // Uygulamada yalnızca dikey yönelimi destekle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupViews()
        fetchPosts()
    }

    func setupViews() {
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    
    func fetchPosts() {
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
        
        // TODO: Henüz oylanmamış anketlerin sayısını hesapla
        let activePollsCount = postViewModels.count //To test constraint of tableView make : 0
        
        if activePollsCount > 0 {
            activePollsButton.isHidden = false
            let font = UIFont(name: "Arial-Bold", size: 17.0)
            activePollsButton.titleLabel?.font = font
            activePollsButton.setTitle("\(activePollsCount) \(activePollsCount == 1 ? "Active Poll" : "Active Polls")", for: .normal)

//            if let titleLabel = activePollsButton.titleLabel {
//                titleLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
//            }
            
            
            tableViewTopConstraint.constant = 110 // TODO: ayrı func. yap :Yukarı kaydırmak istediğiniz mesafe
            
        } else {
            
            activePollsButton.isHidden = true
            tableViewTopConstraint.constant = 20 // Normal pozisyona geri dön
        }
        
        setupActivePollsButtonView()
    }
    
    func setupActivePollsButtonView() {
        activePollsButton.layer.cornerRadius = 20 //activePollsButton.frame.height / 2
        activePollsButton.tintColor = UIColor.systemGroupedBackground

    }
    
}

protocol UpdatePostDelegate: AnyObject {
    func didTapButtonInCell(_ cell: PostTableViewCell)
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource, UpdatePostDelegate {
    
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
        cell.delegate = self
        
        let postViewModel = postViewModels[indexPath.row]
        cell.configure(with: postViewModel)
       
        setUpCellViews(cell)
        
        return cell
        
    }
    
    func setUpCellViews(_ cell: UITableViewCell) {
        cell.layer.borderWidth = 10
        cell.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        cell.layer.cornerRadius = 35
    }
    
    // MyTableViewCellDelegate protokolünün gereksinimlerini uygula
       func didTapButtonInCell(_ cell: PostTableViewCell) {
           // Burada başka bir view controller göster
           print("Button tapped in cell")
           let viewControllerToShow = UpdatePostViewController()
//           viewControllerToShow.delegate = self
           viewControllerToShow.modalPresentationStyle = .pageSheet
           viewControllerToShow.sheetPresentationController?.detents = [.medium()]
           viewControllerToShow.sheetPresentationController?.prefersGrabberVisible = true
           present(viewControllerToShow, animated: true, completion: nil)
       }
}
