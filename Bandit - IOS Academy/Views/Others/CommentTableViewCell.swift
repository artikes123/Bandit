//
//  CommentTableViewCell.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 14.06.2021.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    static let identifier: String = "CommentTableViewCell"
    
    private let avatarImage : UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
    
        return imageView
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Cell'in view'ına eklemeleri yapmak.(view.addsubview gibi)
        contentView.addSubview(avatarImage)
        contentView.addSubview(commentLabel)
        contentView.addSubview(dateLabel)
    }
    
    
    required init?(coder: NSCoder) {
        // init sonrası crash almamak için zorunlu gelen init
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .systemFill
        commentLabel.sizeToFit()
        dateLabel.sizeToFit()
        
        let imageSize : CGFloat = 35
        avatarImage.frame = CGRect(x: 10,
                                   y: 15,
                                   width: imageSize,
                                   height: imageSize)
        
        dateLabel.frame = CGRect(x: avatarImage.right + 10,
                                 y: contentView.height - dateLabel.height,
                                 width: dateLabel.width,
                                 height: dateLabel.height)
        
        commentLabel.frame = CGRect(x: avatarImage.right + 10,
                                    y: avatarImage.bottom/2,
                                 width: contentView.width - avatarImage.height,
                                 height: contentView.height - dateLabel.top)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Eğer cell'i tekrar kullanmak istiyorsak her şeyi sıfırlamamız gerekirki override olmasın
        avatarImage.image = nil
        commentLabel.text = nil
        dateLabel.text = nil
    }
    
    public func configure(with model: PostComment) {
        commentLabel.text = model.text
        dateLabel.text = .date(with: model.date)
        if let url = model.user.profilePictureURL {
            
        }
        else {
            avatarImage.image = UIImage(systemName: "person.crop.circle")
        }
    }
    
}
