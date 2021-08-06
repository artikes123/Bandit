//
//  CurrenUserProfileViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 2.08.2021.
//

import Firebase
import FirebaseAuth
import ProgressHUD
import UIKit

class CurrentUserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let settingsButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "gearshape.fill")
        button.action = #selector(didTapSettings)
        
        
        return button
    }()
    
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.showsVerticalScrollIndicator = false
        collection.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell().identifier)
        //Header'ı register ediyoruz.
        collection.register(ProfileHeaderCollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
        
        return collection
    }()
    
    var user : User
    
    private var posts = [PostModel]()
    
    private var followers = [String]()
    private var following = [String]()
    
    
    //MARK: - Life Cycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        title = user.userName.uppercased()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        navigationItem.rightBarButtonItem = settingsButton
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        let username = UserDefaults.standard.string(forKey: "username") ?? "Me"
        if title == username {
            navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                                                      style: .done,
                                                                                      target: self,
                                                                                      action: #selector(didTapSettings))
        }
        
        fetchPosts()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        
    }
    
    //MARK: - Objc funcs
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        let signInVC = SignInViewController()
        
        do {
            try Auth.auth().signOut()
            navigationController?.pushViewController(signInVC, animated: true)
        }
        catch {
            print("signoutError")
        }
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Funcs
    
    func presentProfilePicturePicker(type: PickerPictureType) {
        let picker = UIImagePickerController()
        
        picker.sourceType = type == .camera ? .camera : .photoLibrary
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func fetchPosts() {
        DatabaseManager.shared.getPosts(for: user) { [weak self] postModels in
            DispatchQueue.main.async {
                
                self?.posts = postModels
                self?.collectionView.reloadData()
                
            }
            
        }
    }
    
    func fetchProfile() {
        StorageManager.shared.downloadProfilePicture(for: user.userName) { [weak self] (url) in
            self?.user = User(userName: (self?.user.userName)!, profilePictureURL: url, identifier: "")
        }
    }
    //MARK: - Posts CollectiovView Funcs
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let postModel = posts[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell().identifier, for: indexPath) as? PostCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: postModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let post = posts[indexPath.row]
        let vc = PostViewController(model: post)
        vc.title = "Video On Profile"
        navigationController?.pushViewController(vc, animated: true)
        // Show Post
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = (view.width - 12)/3
        return CGSize(width: width, height: width * 1.5)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //Dikey olarak itemlerın arasındaki boşlukları belirler
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // 1 line'da kaç item olacağını, aralarındaki uzaklıkları belirleyerek belirliyoruz.
        return 1
    }
    
    //MARK: - Setting the header as UICollectionReusableView
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
                                                                           for: indexPath) as? ProfileHeaderCollectionReusableView
        else {
            return UICollectionReusableView()
        }
        
        // Getting Follower and followings
        
        DatabaseManager.shared.getFollowerFollowing(for: user, type: .followers) { [weak self] followers in
            self?.followers = followers
        }
        
        DatabaseManager.shared.getFollowerFollowing(for: user, type: .following) { [weak self] following in
            self?.followers = following
        }
        
        //View Model'i değiştiriyoruz. View Model değişince View'larımızdaki işlevler de değişmiş oluyor.
        
        let viewModel = ProfileHeaderViewModel(avatarImageURL: self.user.profilePictureURL ,
                                               followerCount: self.followers.count,
                                               followingCount: self.following.count,
                                               isFollowing: nil) //NOTE: BOOL ? NİL : FALSE DEMEK: TRUE İSe NİL DÖNDÜR YOKSA FALSE DÖÖNDÜR DEMEK. YANİ BOOL ?? TRUE'İN TAM TERSİ GİBİ.
        header.delegate = self
        header.configure(with: viewModel)
        
        return header
    }
    // Header'ın boyutunu belirleyeceğiz
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 300)
    }
    
}

//MARK: - ProfileHeader protocols for each Button
extension CurrentUserProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        if self.user.userName == currentUsername {
            // Edit Profile
        }

    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowersButtonWith viewModel: ProfileHeaderViewModel) {
        let vc = UserListViewController(type: .followers, user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapFollowingButtonWith viewModel: ProfileHeaderViewModel) {
        let vc = UserListViewController(type: .following, user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapAvatarWith viewModel: ProfileHeaderViewModel) {
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: {_ in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .camera)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {_ in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .photoLibrary)
            }
        }))
        present(actionSheet, animated: true)
    }
    
}
//MARK: - Picker Delegate

extension CurrentUserProfileViewController {
    
    enum PickerPictureType {
        case camera
        case photoLibrary
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        //upload & Update UI
        ProgressHUD.show("Uploading")
        StorageManager.shared.uploadProfilePicture(with: image) { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            
            case .success(let downloadURL):
                UserDefaults.standard.setValue(downloadURL.absoluteString, forKey: "profile_picture")
                DispatchQueue.main.async {
                    strongSelf.user = User(userName: strongSelf.user.userName, profilePictureURL: downloadURL, identifier: strongSelf.user.identifier)
                    ProgressHUD.showSuccess("Uploaded Image")
                    
                    strongSelf.collectionView.reloadData()
                }
                break
                
            case .failure(let error):
                ProgressHUD.showFailed("Failed to Upload")
                break
                
            }
            
        }
    }
    
}

    





