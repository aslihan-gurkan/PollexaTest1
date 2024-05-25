//
//  ViewController.swift
//  PollexaTest1
//
//  Created by Aslıhan Gürkan on 20.05.2024.
//

import UIKit

protocol UpdatePostDelegate: AnyObject {
    func didUpdateButtonInCell(_ cell: PostTableViewCell)
}

class DiscoverViewController: UIViewController {

    // MARK: - Properties
    let postProvider = PostProvider.shared
    var postViewModels = [PostViewModel]()

    var activityIndicator: UIActivityIndicatorView!
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
        setupActivityIndicator()
        fetchPosts()
    }

    func setupViews() {
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func fetchPosts() {
        activityIndicator.startAnimating()
        postProvider.fetchAll { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
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
    }
    
    func updateActivePolls() {
        
        // TODO: Henüz oylanmamış anketlerin sayısını hesapla
        let activePollsCount = postViewModels.count //To test constraint of tableView make : 0
        
        setupActivePollsButtonView(activePollsCount: activePollsCount)
    }
    
    func setupActivePollsButtonView(activePollsCount: Int) {
        
        activePollsButton.layer.cornerRadius = 20 //activePollsButton.frame.height / 2
        activePollsButton.tintColor = UIColor.systemGroupedBackground
        
        if activePollsCount > 0 {
            activePollsButton.isHidden = false
            
            // Font ayarlarını yap
            let titleFont = UIFont(name: "Arial-BoldMT", size: 17.0)
            let subtitleFont = UIFont(name: "Avenir-Light", size: 14.0)
            
            let titleText = "\(activePollsCount) \(activePollsCount == 1 ? "Active Poll" : "Active Polls")"
            
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: titleFont as Any,
                .foregroundColor: UIColor.white
            ]
            
            let subtitleAttributes: [NSAttributedString.Key: Any] = [
                .font: subtitleFont as Any,
                .foregroundColor: UIColor.white.withAlphaComponent(0.7)
            ]
            
            let subTitleText = NSLocalizedString("SeeDetails", comment: "")
            
            let titleAttributedString = NSAttributedString(string: titleText, attributes: titleAttributes)
            let subtitleAttributedString = NSAttributedString(string: subTitleText, attributes: subtitleAttributes)

            
            let finalAttributedString = NSMutableAttributedString()
            finalAttributedString.append(titleAttributedString)
            finalAttributedString.append(NSAttributedString(string: "\n"))
            finalAttributedString.append(subtitleAttributedString)
            
            
            activePollsButton.setAttributedTitle(finalAttributedString, for: .normal)
            tableViewTopConstraint.constant = 110 // TODO: ayrı func. yap :Yukarı kaydırmak istediğiniz mesafe
        } else {
            activePollsButton.isHidden = true
            tableViewTopConstraint.constant = 20 // Normal pozisyona geri dön
        }
    }
    
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource, UpdatePostDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        //UpdatePostDelegate
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
    
   func didUpdateButtonInCell(_ cell: PostTableViewCell) {
       
       let viewControllerToShow = UpdatePostViewController()

       viewControllerToShow.modalPresentationStyle = .pageSheet
       viewControllerToShow.sheetPresentationController?.detents = [.medium()]
       // show grabber
       viewControllerToShow.sheetPresentationController?.prefersGrabberVisible = true
       present(viewControllerToShow, animated: true, completion: nil)
   }
}
