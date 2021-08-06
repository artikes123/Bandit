//
//  PostGenreSelectionCollectionViewCell.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 23.07.2021.
//

import UIKit

class PostGenreSelectionCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "PostGenreSelectionCollectionViewCell"
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "guitar")
        image.layer.borderColor = CGColor(red: 25, green: 25, blue: 25, alpha: 25)
        image.layer.borderWidth = 0.6
        
        return image
    }()
    
    public var text: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.sizeToFit()
        label.font = .boldSystemFont(ofSize: 8)
        label.text = "Genre"
        label.textColor = .white
        
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(image)
        contentView.addSubview(text)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = 20
        
        image.frame = CGRect(x: 5, y: 2, width: imageSize, height: imageSize)
        image.layer.cornerRadius = imageSize / 2
        image.layer.masksToBounds = true
        
        text.frame = CGRect(x: 32, y: 3, width: contentView.width - imageSize - 10, height: contentView.height - 5)
    }
    
}
