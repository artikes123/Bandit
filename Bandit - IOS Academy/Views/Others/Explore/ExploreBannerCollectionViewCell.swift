//
//  ExploreBannerCollectionViewCell.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 22.06.2021.
//

import UIKit

class ExploreBannerCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExploreBannerCollectionViewCell"
    
    private let image : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let label : UILabel = {
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
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Cell'i tekrar kullanacağımız zaman image ve label sıfırlanması
        image.image = nil
        label.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        image.frame = contentView.bounds
        label.frame = CGRect(x: 10, y: contentView.height - 5 - label.height, width: label.width, height: label.height)
        
        contentView.bringSubviewToFront(label)
    }
    
    func configure(with viewModel: ExploreBannerViewModel) {
        // View model'deki image ve text'i cell'deki label ve image'a atıyoruz.
        image.image = viewModel.imageView
        label.text = viewModel.title
    }
    
}
