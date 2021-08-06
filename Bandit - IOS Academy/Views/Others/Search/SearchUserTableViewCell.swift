//
//  SearchUserTableViewCell.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 26.07.2021.
//

import UIKit

class SearchUserTableViewCell: UITableViewCell {
    
    public let identifier = "SearchUserTableViewCell"
    
    public var username: UILabel = {
       let label = UILabel()
        label.text = "User"
        
        return label
    }()
    
    public var userImage: UIImageView = {
       let image = UIImageView()
        image.sizeToFit()
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.backgroundColor = .lightGray
    
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: self.identifier)
        
        contentView.addSubview(userImage)
        contentView.addSubview(username)
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        username.text = nil
        userImage.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.frame = CGRect(x: 5, y: contentView.height/2 - userImage.height/2, width: 45, height: 45)
        userImage.layer.cornerRadius = userImage.height/2
        
        username.frame = CGRect(x: userImage.right + 5, y: contentView.height/2 - 27, width: contentView.width - userImage.frame.width - 5, height: contentView.height)
        
    }

}
