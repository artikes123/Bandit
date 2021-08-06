//
//  ExploreUserCollectionViewCell.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 22.06.2021.
//

import UIKit

class ExploreUserCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExploreUserCollectionViewCell"
    
    private let profilePicture : UIImageView = {
       let image = UIImageView()
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .secondarySystemBackground
        return image
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textAlignment = .center
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(profilePicture)
        contentView.addSubview(usernameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePicture.image = nil
        usernameLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 55
        profilePicture.frame = CGRect(x: (contentView.width - imageSize)/2, y: 0, width: imageSize, height: imageSize)
        profilePicture.layer.cornerRadius = profilePicture.height / 2
        profilePicture.tintColor = .cyan
        usernameLabel.frame = CGRect(x: (contentView.width - imageSize)/2, y: imageSize - 55, width: imageSize, height: imageSize)
    }
    
    func configure(with viewModel: ExploreUserViewModel) {
        usernameLabel.text = viewModel.userName
        
       
        profilePicture.tintColor = .blue
        profilePicture.image = viewModel.profilePicture
        
        
    }
}
