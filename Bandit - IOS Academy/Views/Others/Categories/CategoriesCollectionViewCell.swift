//
//  CategoriesCollectionViewCell.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 22.07.2021.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoriesCollectionViewCell"
    
    private let image: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(image)
        contentView.addSubview(label)
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        label.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        image.frame = contentView.bounds
        label.frame = CGRect(x: contentView.width/2 - label.width/2, y: contentView.height/2 - label.height/2, width: label.width, height: label.height)
    }
    func configure(with viewModel: CategoriesViewModel) {
        image.image = viewModel.thumbnailImage
        label.text = viewModel.title
    }
}
