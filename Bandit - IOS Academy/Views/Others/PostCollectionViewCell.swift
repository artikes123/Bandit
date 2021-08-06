//
//  PostCollectionViewCell.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 19.07.2021.
//

import AVFoundation
import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    public let identifier = "PostCollectionViewCell"
    
    //MARK: - Life Cycle
    
    private let imageView: UIImageView = {
       let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.backgroundColor = .secondarySystemBackground

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    
    
    func configure(with posts: PostModel) {
        
        StorageManager.shared.getDownloadURL(with: posts){ (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):

                    let asset = AVAsset(url: url)
                    let generator = AVAssetImageGenerator(asset: asset)


                    do {
                        let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                        // Rotating Image
                        let imageFromCGImage = UIImage(cgImage: cgImage)

                        self.imageView.image = imageFromCGImage.rotate(radians: .pi/2)
                    }

                    catch {
                        print("downloading url has failed in cellVC")
                    }

                    break
                case.failure(_):
                    break

                case .none:
                    break
                }
            }

        }
        
     
        
    }
}
