//
//  MusicGenresPostsCollectionViewCell.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 3.08.2021.
//

import UIKit
import AVFoundation

class MusicGenresPostsCollectionViewCell: UICollectionViewCell {
    public let identifier = "MusicGenresPostsCollectionViewCell"
    
    private var reload = true
    
    private let postImage : UIImageView = {
        let image = UIImageView()
        image.sizeToFit()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        
        
        return image
    }()
    
    private let labelView: UIView = {
       let view = UIView()
        view.backgroundColor = .cyan
        view.layer.cornerRadius = 10
        view.alpha = 0.1
        
        return view
    }()
    
    private let postInstrument : UIImageView = {
       let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        
        
        return image
    }()
    
    private let postUserName: UILabel = {
       let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 15))
        label.contentMode = .scaleAspectFill
        label.numberOfLines = 2
        label.font = UIFont(name: "Courier-Bold", size: 16)
        label.textAlignment = .center
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        
        clipsToBounds = true
        
        contentView.addSubview(postImage)
       
        contentView.addSubview(postUserName)
        contentView.addSubview(postInstrument)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        postImage.frame = contentView.bounds
        
        postUserName.frame = CGRect(x: contentView.left + 40 , y: contentView.bottom - 20, width: contentView.width - postInstrument.width - 5 , height: 15)
        
        postInstrument.frame = CGRect(x: contentView.left + 5, y: contentView.bottom - 35, width: 30, height: 30)
        postInstrument.layer.cornerRadius = postInstrument.height/2
        

    }
    
    override func prepareForReuse() {
        postInstrument.image = nil
        postUserName.text = nil
        postImage.image = nil
    }
    
    
    //MARK: -
    
    func configure(with posts: PostModel) {
        if reload {
            StorageManager.shared.getDownloadURL(with: posts) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let url):
                        print("Post url \(url)")
                        let asset = AVAsset(url: url)
                        let generator = AVAssetImageGenerator(asset: asset)

                        do {
                            let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)

                            let imageFromCGImage = UIImage(cgImage: cgImage)

                            self.postImage.image = imageFromCGImage.rotate(radians: .pi/2)
                            self.postUserName.text = posts.user.userName
                            self.postInstrument.image = UIImage(named: "guitar")
                            self.postInstrument.backgroundColor = .cyan
                            self.reload = false
                        }

                        catch {
                            print("downloading url has failed in music genre posts VC")
                        }
                        break
                    case .failure(_):
                        break

                    case.none:
                        break
                    }
                }
            }
        }
    }
}
