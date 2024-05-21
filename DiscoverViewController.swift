//
//  ViewController.swift
//  PollexaTest1
//
//  Created by Aslıhan Gürkan on 20.05.2024.
//

import UIKit

class DiscoverViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var activePollsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupViews()
        setupConstraints()

    }


    private func setupViews() {
        
    }

    private func setupConstraints() {

        activePollsButton.layer.cornerRadius = 60 //ActivePollsButton.frame.height / 2
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath)
        //cell.backgroundColor = rainbow[indexPath.item]
        return cell
        
        //return UITableViewCell()
    }
    
    
}
