//
//  PostCell.swift
//  ChatHook
//
//  Created by Kevin Farm on 5/23/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit

import Firebase

class PublicRoomCell: UITableViewCell {
    
    
    var publicRoom: PublicRoom?{
        didSet{
//
            textLabel?.text = publicRoom?.RoomName
            detailTextLabel?.text = publicRoom?.Author
            if let profileImageUrl = publicRoom?.AuthorPic{
                self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            }
            if let numberOfPosts = publicRoom?.posts{
                if numberOfPosts == 1{
                    self.numberOfPostsLabel.text = "\(numberOfPosts) post"
                }else{
                    self.numberOfPostsLabel.text = "\(numberOfPosts) posts"
                }
            }
            
            
//            if let seconds = message?.timestamp?.doubleValue{
//                let timestampDate = NSDate(timeIntervalSince1970: seconds)
//                let dateFormatter = NSDateFormatter()
//                dateFormatter.dateFormat = "hh:mm:ss a"
//                timeLabel.text = dateFormatter.stringFromDate(timestampDate)
//            }
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 24
            imageView.layer.masksToBounds = true
            imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
            label.text = "HH:MM:SS"
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor.lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfPostsLabel: UILabel = {
        let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor.lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .right
        return label
    }()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(numberOfPostsLabel)
        //addSubview(timeLabel)
        //need x, y, width, height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        numberOfPostsLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        numberOfPostsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        numberOfPostsLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        numberOfPostsLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true

        
//        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17).isActive = true
//        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        timeLabel.heightAnchor.constraint(equalTo: textLabel?.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}//end class PostCell
