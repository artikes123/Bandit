//
//  ProfileHeaderCollectionReusableView.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 9.07.2021.
//

import Firebase
import FirebaseAuth
import SDWebImage
import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowersButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowingButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapAvatarWith viewModel: ProfileHeaderViewModel)
    
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    var viewModel: ProfileHeaderViewModel?
    
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    //Subviews
    
    private let avatarImageView: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.backgroundColor = .secondarySystemBackground
        return image
    }()
    
    //Follow or Edit Profile
    
    private let primaryButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .systemYellow
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return button
    }()
    //Other Buttons
    private let followersButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("Followers", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = .secondarySystemBackground
        
        return button
    }()
    
    private let followingButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("Following", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = .secondarySystemBackground
        
        return button
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.backgroundColor = .secondarySystemBackground
        
        return button
    }()
    
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        clipsToBounds = true
        backgroundColor = .systemBackground
        
        addSubviews()
        configureButtons()
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.addGestureRecognizer(tap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let avatarSize: CGFloat = 130
        avatarImageView.frame = CGRect(x: (width - avatarSize)/2, y: 10, width: avatarSize, height: avatarSize)
        avatarImageView.layer.cornerRadius = avatarImageView.height / 2
        avatarImageView.layer.masksToBounds = true
        
        followersButton.frame = CGRect(x: (width - 210)/2, y: avatarImageView.bottom + 10, width: 100, height: 44)
        followingButton.frame = CGRect(x: followersButton.right + 10, y: avatarImageView.bottom + 10, width: 100, height: 44)
        primaryButton.frame = CGRect(x: (width - 220)/2, y: followingButton.bottom + 15, width: 220, height: 40)
        
        signOutButton.frame = CGRect(x: width, y: height + 10, width: 40, height: 40)
    }
    
    func addSubviews() {
        addSubview(avatarImageView)
        addSubview(primaryButton)
        addSubview(followersButton)
        addSubview(followingButton)
        addSubview(signOutButton)
        
    }
    
    func configureButtons() {
        
        primaryButton.addTarget(self, action: #selector(didTapPrimaryButton), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        
    }

    
    func configure(with viewModel: ProfileHeaderViewModel) {
        
        self.viewModel = viewModel
        // Set Up Header
        followersButton.setTitle("\(viewModel.followerCount)\nFollowers", for: .normal)
        followingButton.setTitle("\(viewModel.followingCount)\nFollowing", for: .normal)
        if let avatarURL = viewModel.avatarImageURL {
            avatarImageView.sd_setImage(with: avatarURL, completed: nil)
        }
        else {
            avatarImageView.image = UIImage(named: "Test")
        }
        
        if let isFollowing = viewModel.isFollowing {
            
            primaryButton.backgroundColor = isFollowing ? .secondarySystemBackground : .systemPink // eğer following button true is secondrysystem background yap yoksa pink yap
            primaryButton.setTitle(isFollowing ? "Unfollow": "Follow", for: .normal) // eğer is following true ise follow otherwise unfollow yap
        }
        else {
            primaryButton.backgroundColor = .secondarySystemBackground
            primaryButton.setTitle("Edit Profile", for: .normal)
        }
    }
    //MARK: - OBJ Funcs
    @objc func didTapPrimaryButton() {
        guard let viewModel = self.viewModel else {
            return
        }
        delegate?.profileHeaderCollectionReusableView(self, didTapPrimaryButtonWith: viewModel)
    }
    
    @objc func didTapFollowersButton() {
        guard let viewModel = self.viewModel else {
            return
        }
        delegate?.profileHeaderCollectionReusableView(self, didTapFollowersButtonWith: viewModel)
    }
    
    @objc func didTapFollowingButton() {
        guard let viewModel = self.viewModel else {
            return
        }
        delegate?.profileHeaderCollectionReusableView(self, didTapFollowingButtonWith: viewModel)
    }
    
    @objc func didTapAvatar() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        delegate?.profileHeaderCollectionReusableView(self, didTapAvatarWith: viewModel)

    }
    
    @objc func didTapSignOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("can not sign out")
        }

    }
}
