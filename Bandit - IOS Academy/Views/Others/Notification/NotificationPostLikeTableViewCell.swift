//
//  NotificationPostLikeTableViewCell.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 7.07.2021.
//

import UIKit

protocol NotificationPostLikeTableViewCellDelegate: AnyObject {
    
    func notificationPostLikeTableViewCellDelegate(_ cell: NotificationPostLikeTableViewCell, didTapPostWith identifier: String)
    
}

class NotificationPostLikeTableViewCell: UITableViewCell {
    
    weak var delegate: NotificationPostLikeTableViewCellDelegate?
    
    var postID: String?
    
    private let postThumbnailImageView: UIImageView = {
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
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    static let identifier = "NotificationPostLikeTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(postThumbnailImageView)
        contentView.addSubview(label)
        contentView.addSubview(dateLabel)
        selectionStyle = .none
        
        postThumbnailImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapThumbnailImage))
        postThumbnailImageView.addGestureRecognizer(tap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapThumbnailImage() {
        guard let id = postID else {
            return
        }
        delegate?.notificationPostLikeTableViewCellDelegate(self, didTapPostWith: id)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        postThumbnailImageView.frame = CGRect(x: contentView.width - 50, y: 3, width: 50, height: contentView.height - 6)
        postThumbnailImageView.layer.cornerRadius = postThumbnailImageView.width/2
        postThumbnailImageView.layer.masksToBounds = true
        
        label.sizeToFit()
        dateLabel.sizeToFit()
        
        let labelSize = label.sizeThatFits(CGSize(width: contentView.width - 10 - postThumbnailImageView.width - 5, height: contentView.height - 40))
        label.frame = CGRect(x:  10, y: 0, width: labelSize.width, height: labelSize.height)
        
        dateLabel.frame = CGRect(x: 5,
                                 y: contentView.height - 40,
                                 width: contentView.width - postThumbnailImageView.width ,
                                 height: 40)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postThumbnailImageView.image = nil
        label.text = nil
        dateLabel.text = nil
    }
    
    func configure(with postfileName: String, model: NotificationStruct) {
        postThumbnailImageView.image = UIImage(named: "Test")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
        postID = postfileName
        
        
    }
    
}
