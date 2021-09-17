//
//  MusicGenrePostsViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 3.08.2021.
//

import UIKit

class MusicGenrePostsViewController: UIViewController {
    
    //MARK: - Vars and lets
    
    private var posts = [PostModel]()
    
    private var selectedMusicGenre: MusicCategories
    
    let refresh = UIRefreshControl()
    

    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MusicGenresPostsCollectionViewCell.self, forCellWithReuseIdentifier: MusicGenresPostsCollectionViewCell().identifier)
        
        return collectionView
    }()
    
    //MARK: - Life Cycle
    init(with genre: MusicCategories) {
        selectedMusicGenre = genre
        super.init(nibName: nil, bundle: nil)
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refresh.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refresh
        
        title = selectedMusicGenre.title
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        getVideosNamesAndUsers()
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
//MARK: - OBJC func
    @objc func didPullToRefresh(_ sender: UIRefreshControl) {
        refresh.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.getVideosNamesAndUsers()
            self.refresh.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
//MARK: -
    private func getVideosNamesAndUsers() {
        DatabaseManager.shared.getGenrePosts(for: selectedMusicGenre) { [weak self] (postsDictionaryArray) in
            
            DispatchQueue.main.async {
                for (filename , valueDictionary) in postsDictionaryArray {
                    guard let username = valueDictionary["username"] as? String else {return}
                    guard let bandit = valueDictionary["bandits"] as? [String]? else { return }
                    guard let caption = valueDictionary["caption"] as? String?  else {return}
                    
                    self?.downloadUserProfileImage(for: username,completion: { (url) in
                        
                        let userWithName = User(userName: username, profilePictureURL: url, identifier: "", instrument: "")
                        
                        guard let url = URL(string: filename + ".mov") else {return}
                        
                        let genre = (self?.selectedMusicGenre.title)!
                        
                        let model = PostModel(postURL: url, user: userWithName, fileName: filename, caption: caption ?? "", postGenre: genre, banditFileNames: bandit, likedByCurrentUser: false)
                        self?.posts.removeAll()
                        self?.posts.append(model)
                        self?.collectionView.reloadData()
                    })
                    
                    
                    
                }
            }
        }
    }
    
    private func downloadUserProfileImage(for username: String, completion: @escaping (URL?) -> Void) {
        StorageManager.shared.downloadProfilePicture(for: username) { (url) in
            completion(url)
        }
 }
}

//MARK: - CollectionView protocols

extension MusicGenrePostsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postModel = posts[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicGenresPostsCollectionViewCell().identifier, for: indexPath) as? MusicGenresPostsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.layer.cornerRadius = 10
        cell.configure(with: postModel) { (url) in
            self.posts[indexPath.row].postURL = url
        }
        self.collectionView = collectionView
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = PostViewController(model: posts[indexPath.row], isPostInMusicGenre: true)
        vc.modalPresentationStyle = .fullScreen

        present(vc, animated: true, completion: nil)
        
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

}
