//
//  PostTableViewCell.swift
//  PollexaTest1
//
//  Created by Aslıhan Gürkan on 20.05.2024.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var VotedDateLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftLikeButton: UIButton!
    @IBOutlet weak var rightLikeButton: UIButton!
    @IBOutlet weak var leftPercentage: UILabel!
    @IBOutlet weak var rightPercentage: UILabel!
    @IBOutlet weak var totalVotesLabel: UILabel!
    
    var votesForLeftImageCount: Int = 0
    var votesForRightImageCount: Int = 0
    private var userVote: UserVote = .none
    
    var totalVotes: Int {
        return votesForLeftImageCount + votesForRightImageCount
    }
    
    enum UserVote {
        case none
        case leftImage
        case rightImage
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
        updatePercentageLabels()
    }
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        voteForLeftImage()
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        voteForRightImage()
    }
    
    func updateButtons() {
        leftLikeButton.setImage(UIImage(systemName: userVote == .leftImage ? "hand.thumbsup.fill" : "hand.thumbsup"), for: .normal)
        rightLikeButton.setImage(UIImage(systemName: userVote == .rightImage ? "hand.thumbsup.fill" : "hand.thumbsup"), for: .normal)
    }
    
    func voteForLeftImage() {
        updateVotes(newVote: .leftImage)
    }

    func voteForRightImage() {
        updateVotes(newVote: .rightImage)
    }
    
    private func updateVotes(newVote: UserVote) {
        
        switch userVote {
            case .none:
                updateVoteCount(for: newVote, increment: true)
            case .leftImage:
                if newVote == .leftImage {
                    updateVoteCount(for: .leftImage, increment: false)
                } else {
                    updateVoteCount(for: .leftImage, increment: false)
                    updateVoteCount(for: .rightImage, increment: true)
                }
            case .rightImage:
                if newVote == .rightImage {
                    updateVoteCount(for: .rightImage, increment: false)
                } else {
                    updateVoteCount(for: .rightImage, increment: false)
                    updateVoteCount(for: .leftImage, increment: true)
                }
            }
        
        userVote = (userVote == newVote) ? .none : newVote
        updatePercentageLabels()
        updateButtons()
    }
    
    private func updateVoteCount(for vote: UserVote, increment: Bool) {
       if vote == .leftImage {
           votesForLeftImageCount = max(0, votesForLeftImageCount + (increment ? 1 : -1))
       } else if vote == .rightImage {
           votesForRightImageCount = max(0, votesForRightImageCount + (increment ? 1 : -1))
       }
   }
    
    func updatePercentageLabels() {
        
        if totalVotes > 0 {
//            let leftImagePercentage = Double(votesForLeftImageCount / totalVotes) * 100
//            let rightImagePercentage = Double(votesForRightImageCount / totalVotes) * 100
            let leftImagePercentage = (Double(votesForLeftImageCount) / Double(totalVotes)) * 100
            let rightImagePercentage = (Double(votesForRightImageCount) / Double(totalVotes)) * 100
            leftPercentage.text = String(format: "%.0f%%", leftImagePercentage)
            rightPercentage.text = String(format: "%.0f%%", rightImagePercentage)
            
            //make hidden if user didin't vote
            leftPercentage.isHidden = userVote == .none
            rightPercentage.isHidden = userVote == .none
        } else {
            leftPercentage.text = "0%"
            rightPercentage.text = "0%"
            leftPercentage.isHidden = true
            rightPercentage.isHidden = true
        }
        updateTotalVotesLabel()
    }
    
    func configure(with viewModel: PostViewModel) {
        profileImage.image = viewModel.userImage
        userNameLabel.text = viewModel.username
        contentLabel.text = viewModel.content
        let dateRemainder = calculateDateRemainder(viewModel.createdDate)
        dateLabel.text = dateRemainder
        leftImage.image = viewModel.options[0].image
        rightImage .image = viewModel.options[1].image
        
        updateTotalVotesLabel()
    }
    
    private func updateTotalVotesLabel() {
        totalVotesLabel.text = "\(totalVotes) Total Votes"
    }
    
    private func setupViews() {
        //TODO: fonksiyon değişikliği ve image kenarları
        leftImage.layer.cornerRadius = 8 //leftImage.layer.cornerRadius / 2
        rightImage.layer.cornerRadius = 8 //rightImage.layer.cornerRadius / 2
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        
        leftLikeButton.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .small)
        rightLikeButton.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .small)
    }

    private func calculateDateRemainder(_ date: Date) -> String? {

        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: currentDate)
        
        let timeUnits = [
            ("year", components.year),
            ("month", components.month),
            ("day", components.day),
            ("hour", components.hour),
            ("minute", components.minute),
            ("second", components.second)
        ]
        
        for (unit, value) in timeUnits {
            if let value = value, value > 0 {
                return value == 1 ? "1 \(unit) ago" : "\(value) \(unit)s ago "
            }
        }
        
        return "just now"
    }
}
