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
    
    var viewModel: PostViewModel?
    
    var votesForLeftImageCount: Int = 0
    var votesForRightImageCount: Int = 0
    var userVote: UserVote = .none
    
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
    
    func configure(with viewModel: PostViewModel) {
        
        self.viewModel = viewModel
        profileImage.image = viewModel.userImage
        userNameLabel.text = viewModel.username
        contentLabel.text = viewModel.content
        
        dateLabel.text = DateHelper.calculateDateRemainder(from: viewModel.createdDate, isVote: false)
        
        let lastVotedContent = NSLocalizedString("lastVoted", comment: "")
        let lastVotedDateRemainder = DateHelper.calculateDateRemainder(from: viewModel.lastVotedAt, isVote: true)
        VotedDateLabel.text = "\(lastVotedContent) \(lastVotedDateRemainder)"
        
        leftImage.image = viewModel.options[0].image
        rightImage .image = viewModel.options[1].image
        
        votesForLeftImageCount = viewModel.votesForLeftImage
        votesForRightImageCount = viewModel.votesForRightImage
        
        updateTotalVotesLabel()
    }
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        voteForLeftImage()
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        voteForRightImage()
    }
    
    func voteForLeftImage() {
        updateVotes(newVote: .leftImage)
    }
    
    func voteForRightImage() {
        updateVotes(newVote: .rightImage)
    }
    
    func updateVotes(newVote: UserVote) {
        
        guard let viewModel = viewModel else { return }
        let increment: Bool
        
        switch userVote {
        case .none:
            increment = true
            updateVoteCount(for: newVote, increment: true)
        case .leftImage:
            if newVote == .leftImage {
                increment = false
                updateVoteCount(for: .leftImage, increment: false)
            } else {
                increment = true
                updateVoteCount(for: .leftImage, increment: false)
                updateVoteCount(for: .rightImage, increment: true)
            }
        case .rightImage:
            if newVote == .rightImage {
                increment = false
                updateVoteCount(for: .rightImage, increment: false)
            } else {
                increment = true
                updateVoteCount(for: .rightImage, increment: false)
                updateVoteCount(for: .leftImage, increment: true)
            }
        }
        
        userVote = (userVote == newVote) ? .none : newVote
        updatePercentageLabels()
        updateButtonStates()
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
    
    private func updateTotalVotesLabel() {
        
        let localizedTotalVotes = languageControl()
        totalVotesLabel.text = "\(totalVotes) \(localizedTotalVotes)"
    }
    
    func updateButtonStates() {
        leftLikeButton.setImage(UIImage(systemName: userVote == .leftImage ? "hand.thumbsup.fill" : "hand.thumbsup"), for: .normal)
        rightLikeButton.setImage(UIImage(systemName: userVote == .rightImage ? "hand.thumbsup.fill" : "hand.thumbsup"), for: .normal)
    }
    
    private func languageControl() -> String {
        let localizedTotalVotesSingular = NSLocalizedString("totalVote", comment: "")
        let localizedTotalVotesPlural = NSLocalizedString("totalVotes", comment: "")
        
        let isEnglish = DateHelper.localeControl()
        
        if isEnglish {
            return totalVotes == 1 ? localizedTotalVotesSingular : localizedTotalVotesPlural
        } else {
            return localizedTotalVotesPlural
        }
    }
    
    private func setupViews() {
        let cornerRadius: CGFloat = 8 //leftImage.layer.cornerRadius / 2
        leftImage.layer.cornerRadius = cornerRadius
        rightImage.layer.cornerRadius = cornerRadius
        
        leftImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner] // Sol üst ve sol alt köşeleri maskeler
        rightImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner] // Sağ üst ve sağ alt köşeleri maskeler
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        
        leftLikeButton.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .small)
        rightLikeButton.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .small)
    }
  
    weak var delegate: UpdatePostDelegate?
    
    @IBAction func detailButtonTapped(_ sender: Any) {
        delegate?.didUpdateButtonInCell(self)
    }
    
}
