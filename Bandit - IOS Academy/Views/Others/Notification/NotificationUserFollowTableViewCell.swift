//
//  NotificationUserFollowTableViewCell.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 7.07.2021.
//

import UIKit

protocol NotificationUserFollowTableViewCellDelegate : AnyObject {
    func notificationUserFollowTableViewCellDelegate(_ cell: NotificationUserFollowTableViewCell, didTapFollowFor username: String)
    func notificationUserFollowTableViewCellDelegate(_ cell: NotificationUserFollowTableViewCell, didTapAvatarFor username: String)
}

class NotificationUserFollowTableViewCell: UITableViewCell {

    weak var delegate: NotificationUserFollowTableViewCellDelegate?
    
    static let identifier = "NotificationUserFollowTableViewCell"
    
    //Avatar, label, follow button
    
    private let avatarImageView: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        

        return image
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    private let followButton: UIButton = {
       let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    var username: String?
    
    //MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
        contentView.addSubview(dateLabel)
        selectionStyle = .none
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))

        avatarImageView.addGestureRecognizer(tap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - obj func
    
    @objc func didTapFollowButton() {

        guard let username = username else {
            return
        }
        
        followButton.setTitle("Following", for: .normal)
        followButton.backgroundColor = .clear
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        
        delegate?.notificationUserFollowTableViewCellDelegate(self, didTapFollowFor: username)
    }
    
    @objc func didTapAvatar() {

        guard let username = username else {
            print("something wrong about pushing avatar")
            return
        }

        delegate?.notificationUserFollowTableViewCellDelegate(self, didTapAvatarFor: username)
    }
    
  //MARK:- Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let iconSize: CGFloat = 50
        
        avatarImageView.frame = CGRect(x: 10, y: (contentView.height - iconSize)/2, width: iconSize, height: iconSize)
        avatarImageView.layer.cornerRadius = avatarImageView.width/2
        avatarImageView.layer.masksToBounds = true
        followButton.sizeToFit()
        
        followButton.frame = CGRect(x: contentView.width - 10 - followButton.width - 20, y: (contentView.height - 50)/2 + 10, width: followButton.width + 20, height: 30)
        
        label.sizeToFit()
        dateLabel.sizeToFit()
        
        let labelSize = label.sizeThatFits(CGSize(width: contentView.width - 30 - followButton.width - iconSize, height: contentView.height - 40))
        label.frame = CGRect(x: avatarImageView.right + 10, y: contentView.height/2 - 10, width: labelSize.width, height: labelSize.height)
        dateLabel.frame = CGRect(x: avatarImageView.right,
                                 y: contentView.height - 30,
                                 width: contentView.width - avatarImageView.width - followButton.width ,
                                 height: 40)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        label.text = nil
        dateLabel.text = nil
        //Follow tuşuna bir daha bastığımız zaman nolcağını belirliyoruz
        
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = .systemBlue
        followButton.layer.borderWidth = 0
        followButton.layer.borderColor = nil
        
    }
    
    //MARK: -
    
    func configure(with username: String, model: NotificationStruct) {
        avatarImageView.image = UIImage(named: "Test")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
        self.username = username
    }

}
