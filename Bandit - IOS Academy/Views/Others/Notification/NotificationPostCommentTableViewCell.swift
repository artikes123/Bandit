//
//  NotificationPostCommentTableViewCell.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 7.07.2021.
//

import UIKit

protocol NotificationPostCommentTableViewCellDelegate: AnyObject {
    
    func notificationPostCommentTableViewCellDelegate(_ cell: NotificationPostCommentTableViewCell, didTapPostWith identifier: String)
    
}

class NotificationPostCommentTableViewCell: UITableViewCell {
    
    weak var delegate: NotificationPostCommentTableViewCellDelegate?
    
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
    
    static let identifier = "NotificationPostCommentTableViewCell"
    
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
        //MARK: - thumbnail image'a dokunulunca delegate içerisindeki ID'yi güncelliyoruz ki ViewController'da bu delegate çağırılınca içerisindeki ID değeri belli olsun
        guard let id = postID else {
            return
        }
        delegate?.notificationPostCommentTableViewCellDelegate(self, didTapPostWith: id)
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
            
            dateLabel.frame = CGRect(x: 8,
                                     y: contentView.height - 50,
                                     width: contentView.width - postThumbnailImageView.width ,
                                     height: contentView.height - 10)
            
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            postThumbnailImageView.image = nil
            label.text = nil
            dateLabel.text = nil
        }
        
        func configure(with postFileName: String, model: NotificationStruct) {
            postThumbnailImageView.image = UIImage(named: "Test")
            label.text = model.text
            dateLabel.text = .date(with: model.date)
            
            postID = postFileName
        }
        
        
    }

