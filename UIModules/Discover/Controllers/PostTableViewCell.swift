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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func setupConstraints() {

        profileImage.layer.cornerRadius = profileImage.frame.width / 2
    }
    
    func configure(with viewModel: PostViewModel) {
        profileImage.image = viewModel.userImage
        userNameLabel.text = viewModel.username
        
        let dateRemainder = calculateDateRemainder(viewModel.createdDate)
        dateLabel.text = dateRemainder
        leftImage.image = viewModel.options[0].image
        rightImage .image = viewModel.options[1].image
        
        
        let totalVotes = 6
        totalVotesLabel.text = "\(totalVotes) Total Votes"
        // Oy oranları ve butonlar buraya atanacak
        
    }

    
    private func setupViews() {
//        cell.layer.borderWidth = 10
//        cell.layer.cornerRadius = 35
    }
    
    private func calculateDateRemainder(_ date: Date) -> String? {
//        let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "d MMM y, h:mm a"
//            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//            
//            guard let date = dateFormatter.date(from: dateString) else {
//                return nil
//            }
            
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: now)
            
            if let year = components.year, year > 0 {
                return year == 1 ? "1 year ago" : "\(year) years ago"
            }
            
            if let month = components.month, month > 0 {
                return month == 1 ? "1 month ago" : "\(month) months ago"
            }
            
            if let day = components.day, day > 0 {
                return day == 1 ? "1 day ago" : "\(day) days ago"
            }
            
            if let hour = components.hour, hour > 0 {
                return hour == 1 ? "1 hour ago" : "\(hour) hours ago"
            }
            
            if let minute = components.minute, minute > 0 {
                return minute == 1 ? "1 minute ago" : "\(minute) minutes ago"
            }
            
            if let second = components.second, second > 0 {
                return second == 1 ? "1 second ago" : "\(second) seconds ago"
            }
            
            return "just now"
        
        
        
        
    }
    
}
