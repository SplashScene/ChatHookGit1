//
//  CommentViewCell.swift
//  ChatHook
//
//  Created by Kevin Farm on 8/24/16.
//  Copyright © 2016 splashscene. All rights reserved.
//

import UIKit
import Firebase

class CommentViewCell: UITableViewCell {
    var likeRef: FIRDatabaseReference!
    var commentViewController: CommentViewController?
    
    var userComment: Comment?{
        didSet{
            self.profileImageView.loadImageUsingCacheWithUrlString(urlString: (userComment?.authorPic!)!)
            self.userNameLabel.text = userComment?.authorName
            self.cityAndStateLabel.text = userComment?.cityAndState
            self.descriptionText.text = userComment?.commentText
            
            if let seconds = userComment?.timestamp?.doubleValue{
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM d, hh:mm a"
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
        }
    }
    
    let cellContainerView: MaterialView = {
        let containerView = MaterialView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.backgroundColor = UIColor.white
            containerView.layer.cornerRadius = 5.0
            containerView.layer.masksToBounds = true
            containerView.sizeToFit()
        return containerView
    }()
    
    let profileImageView: MaterialImageView = {
        let imageView = MaterialImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  18.0)
            label.backgroundColor = UIColor.clear
            label.textColor = UIColor.blue
            label.sizeToFit()
        return label
    }()
    
    let cityAndStateLabel: UILabel = {
        let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: FONT_AVENIR_LIGHT, size:  12.0)
            label.backgroundColor = UIColor.clear
            label.textColor = UIColor.lightGray
            label.sizeToFit()
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor.lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
        return label
    }()
    
    var likeCount: UILabel = {
        let label = UILabel()
            label.text = "0"
            label.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  12.0)
            label.textColor = UIColor.darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
        return label
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
            label.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  12.0)
            label.textColor = UIColor.darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
        return label
    }()
    
    let descriptionText: UILabel = {
        let descripTextView = UILabel()
            descripTextView.translatesAutoresizingMaskIntoConstraints = false
            descripTextView.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  14.0)
            descripTextView.textColor = UIColor.darkGray
            descripTextView.numberOfLines = 0
            descripTextView.sizeToFit()
        return descripTextView
    }()
 
    let separatorLineView: UIView = {
        let sepLineView = UIView()
            sepLineView.translatesAutoresizingMaskIntoConstraints = false
            sepLineView.backgroundColor = UIColor.darkGray
        return sepLineView
    }()
    
    let commentContainerView: UIView = {
        let commentContainerView = UIView()
            commentContainerView.translatesAutoresizingMaskIntoConstraints = false
            commentContainerView.backgroundColor = UIColor.white
        return commentContainerView
    }()
    
    var commentCount: UILabel = {
        let label = UILabel()
            label.text = "0"
            label.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  12.0)
            label.textColor = UIColor.darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
            label.text = "Comments"
            label.font = UIFont(name: FONT_AVENIR_MEDIUM, size:  12.0)
            label.textColor = UIColor.darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
        return label
    }()
    
    //MARK: - Init Methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(cellContainerView)
        setupCellContainerView()
    }
    
    //MARK: - Setup Methods
    
    func setupCellContainerView(){
        cellContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        cellContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cellContainerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cellContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -4).isActive = true
        
        cellContainerView.addSubview(profileImageView)
        cellContainerView.addSubview(userNameLabel)
        cellContainerView.addSubview(timeLabel)
        cellContainerView.addSubview(cityAndStateLabel)
        cellContainerView.addSubview(descriptionText)
        
        profileImageView.leftAnchor.constraint(equalTo: cellContainerView.leftAnchor, constant: 8).isActive = true
        profileImageView.topAnchor.constraint(equalTo: cellContainerView.topAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        userNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: cellContainerView.topAnchor, constant: 8).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        
        cityAndStateLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        cityAndStateLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: -4).isActive = true
        
        descriptionText.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        descriptionText.topAnchor.constraint(equalTo: cityAndStateLabel.bottomAnchor).isActive = true
        descriptionText.rightAnchor.constraint(equalTo: cellContainerView.rightAnchor, constant: -8).isActive = true

    }
}


