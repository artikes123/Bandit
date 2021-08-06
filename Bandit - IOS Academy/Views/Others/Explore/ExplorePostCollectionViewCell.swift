//
//  ExplorePostCollectionViewCell.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 22.06.2021.
//

import UIKit

class ExplorePostCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExplorePostCollectionViewCell"
    
    private let thumbnailImage :UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let label : UILabel = {
       let label = UILabel()
        label.contentMode = .scaleAspectFit
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(thumbnailImage)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage.image = nil
        label.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let captionHeight = contentView.height / 5
        thumbnailImage.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height - captionHeight)
        thumbnailImage.layer.cornerRadius = contentView.width/8
        label.frame = CGRect(x: 5, y: contentView.height - captionHeight, width: contentView.width, height: captionHeight)
        label.font = .systemFont(ofSize: 20, weight: .semibold)
    
        label.textColor = .white
        
    }
    
    func configure(with viewModel: ExplorePostViewModel) {
        thumbnailImage.image = viewModel.thumbnailImage
        label.text = viewModel.caption
    }
}
