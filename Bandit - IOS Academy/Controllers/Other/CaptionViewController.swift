//
//  CaptionViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 5.07.2021.
//

import ProgressHUD
import UIKit

class CaptionViewController: UIViewController {
    
    let videoURL: URL
    
    private let selectYourPostGenre: UILabel = {
       let text = UILabel()
        text.text = "Please select your post's genre"
        text.font = .italicSystemFont(ofSize: 18)
        text.textColor = .white
        
        return text
    }()
    
    private let captionTextView : UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        textView.font = UIFont.boldSystemFont(ofSize: 14)
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        
        
        return textView
    }()
    
    private let musicGenreCell: UICollectionViewCell = {
        let cell = UICollectionViewCell()
        return cell
        
    }()
    
    private let thumbnailImage: UIImageView = {
       let image = UIImageView()
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    private var genreSelectionCellType = [MusicCategories]()

    private var musicGenreCV: UICollectionView?
    
    private var selectedGenre = [String]()
    
    var selectedCellArray = [UICollectionViewCell]()
    
    //MARK: - Init
    
    init(with videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureViews()
        configureCollectionView()
        
        title = "New Post"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
        
        
        let fileManagerThumbnailImage = UIImage().getSavedImage(from: "thumbnailImage")
        thumbnailImage.image = fileManagerThumbnailImage?.rotate(radians: .pi/2)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captionTextView.frame = CGRect(x: view.width/4 + 10 , y: view.safeAreaInsets.top + 20, width: view.width - (view.width/4 + 10) - 5, height: 150).integral
        selectYourPostGenre.frame = CGRect(x: 5, y: captionTextView.bottom + 10, width: view.width - 5, height: 40)
        musicGenreCV?.frame = CGRect(x: 5, y: selectYourPostGenre.bottom + 5, width: view.width - 5, height: 40)
        thumbnailImage.frame = CGRect(x: 5, y: view.safeAreaInsets.top + 20, width: view.width/4, height: 150).integral
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captionTextView.becomeFirstResponder()
        
    }
    
    private func configureViews() {
        view.addSubview(captionTextView)
        view.addSubview(thumbnailImage)
        view.addSubview(selectYourPostGenre)
        
        genreSelectionCellType.append(MusicCategories.Rock)
        genreSelectionCellType.append(MusicCategories.Pop)
        genreSelectionCellType.append(MusicCategories.HipHop)
        genreSelectionCellType.append(MusicCategories.RB)
        genreSelectionCellType.append(MusicCategories.Electronic)
        genreSelectionCellType.append(MusicCategories.Metal)
        genreSelectionCellType.append(MusicCategories.Blues)
        genreSelectionCellType.append(MusicCategories.Classic)
    }
    
    //MARK: - Private Funcs
    
    private func configureCollectionView() {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets  = NSDirectionalEdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.23), heightDimension: .fractionalHeight(1)), subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        let layoutSection = NSCollectionLayoutSection(group: group)
        
        layoutSection.orthogonalScrollingBehavior = .continuous
        
        let compositionalLayout = UICollectionViewCompositionalLayout(section: layoutSection)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        
        collectionView.backgroundColor = .clear
        
        collectionView.register(PostGenreSelectionCollectionViewCell.self, forCellWithReuseIdentifier: PostGenreSelectionCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        self.musicGenreCV = collectionView
        
    }
    
    //MARK: - Objc Func
    @objc func didTapPost() {
        
        captionTextView.resignFirstResponder()
        let caption = captionTextView.text ?? ""
        // Generate a video name that is unique based on ID
        //upload video
        ProgressHUD.show("Posting")
        let newVideoName = StorageManager.shared.generateVideoName()
        let genre = self.selectedGenre.first ?? ""
    
        StorageManager.shared.uploadVideoURL(from: videoURL, fileName: newVideoName + ".mov", genre: genre) { [weak self] (success) in
            
            DispatchQueue.main.async {
                if success {
                    HapticsManager.shared.vibrate(for: .success)
                    ProgressHUD.dismiss()
                    //Update database
                    DatabaseManager.shared.insertPostsToDBUsers(with: newVideoName , caption: caption, genre: genre) { (databaseUpdated) in
                        if databaseUpdated{
                            DatabaseManager.shared.insertPostsToDB(with: newVideoName, genre: genre) { (completed) in
                                if completed {
                                    //reset camera switch to feed
                                    self?.navigationController?.popToRootViewController(animated: true)
                                    self?.tabBarController?.selectedIndex = 0
                                    self?.tabBarController?.tabBar.isHidden = false
                                }
                            }
                        }
                        
                    }
                    
                }
                else {
                    HapticsManager.shared.vibrate(for: .error)
                    ProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Whoops", message: "Unable to upload video", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    func uploadGenreToDB() {
        
    }
    
}
// MARK: - CV Extension

extension CaptionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreSelectionCellType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            HapticsManager.shared.vibrateForSelection()
        }
        
        let selectedGenreName = genreSelectionCellType[indexPath.row].title
        
        
        guard let selectedCell = collectionView.cellForItem(at: indexPath) else {return}
        
        if !selectedCellArray.contains(selectedCell) {
            selectedCellArray.removeAll()
            selectedCellArray.append(selectedCell)
            
            selectedCell.isSelected = true
            
            selectedGenre.removeAll()
            selectedGenre.append(selectedGenreName)
        }
        
        else {
            selectedCellArray.removeAll()
            
            selectedCell.isSelected = false
            
            selectedGenre.removeAll()
            
        }
        print(self.selectedGenre)
        print("selected cell aray count is \(selectedCellArray.count)")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellItem = genreSelectionCellType[indexPath.row]
        
        switch cellItem {
        
        case .Blues:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostGenreSelectionCollectionViewCell.identifier, for: indexPath) as? PostGenreSelectionCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.text.text = cellItem.title
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .systemBlue
            return cell
            
        case .Classic:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostGenreSelectionCollectionViewCell.identifier, for: indexPath) as? PostGenreSelectionCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.text.text = cellItem.title
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .systemGray
            return cell
            
        case .Electronic:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostGenreSelectionCollectionViewCell.identifier, for: indexPath) as? PostGenreSelectionCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.text.text = cellItem.title
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .orange
            return cell
            
        case .HipHop:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostGenreSelectionCollectionViewCell.identifier, for: indexPath) as? PostGenreSelectionCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.text.text = cellItem.title
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .systemGreen
            return cell
            
        case .Metal:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostGenreSelectionCollectionViewCell.identifier, for: indexPath) as? PostGenreSelectionCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.text.text = cellItem.title
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .darkGray
            return cell
            
        case .RB:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostGenreSelectionCollectionViewCell.identifier, for: indexPath) as? PostGenreSelectionCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.text.text = cellItem.title
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .systemTeal
            return cell
            
        case .Pop:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostGenreSelectionCollectionViewCell.identifier, for: indexPath) as? PostGenreSelectionCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.text.text = cellItem.title
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .systemIndigo
            return cell
        case .Rock:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostGenreSelectionCollectionViewCell.identifier, for: indexPath) as? PostGenreSelectionCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.text.text = cellItem.title
            cell.layer.cornerRadius = 10
            cell.backgroundColor = .systemRed
            return cell
        }
        
    }
    
    
}
