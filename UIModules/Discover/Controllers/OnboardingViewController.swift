//
//  OnboardingViewController.swift
//  PollexaTest1
//
//  Created by Aslıhan Gürkan on 22.05.2024.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()

    }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        // Trigger Segue
        performSegue(withIdentifier: "showDiscoverViewController", sender: self)
    }
}
