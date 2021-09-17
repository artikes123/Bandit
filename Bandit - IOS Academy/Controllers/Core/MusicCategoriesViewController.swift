//
//  MusicCategoriesViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 22.07.2021.
//

import UIKit
import AMTabView

class MusicCategoriesViewController: UIViewController {
    
   private var categoriesCollectionView: UICollectionView?
    
    private var categoriesCell = [MusicCategories]()
    
    
    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barStyle = .default
        searchBar.layer.cornerRadius = 8
        searchBar.placeholder = "Search for people"
        
        return searchBar
    }()
        
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCategoriesModel()
        setUpCollectionView()
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearchButton))
        
        navigationItem.rightBarButtonItem = barButtonItem
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoriesCollectionView?.frame = view.bounds
        searchBar.frame = CGRect(x: 5, y: 0, width: (navigationController?.navigationBar.width)! - 10 , height: (navigationController?.navigationBar.height)!)
    }
    
    func setUpCollectionView() {
        
        //Layout'ta oluşturulacak item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 4, bottom: 1, trailing: 4)
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25)), subitems: [item])
        horizontalGroup.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        let layoutSection = NSCollectionLayoutSection(group: horizontalGroup)
    
        let layout = UICollectionViewCompositionalLayout(section: layoutSection)
        // Creating CollectionView by above
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        self.categoriesCollectionView = collectionView
        
    }
    
    private func configureCategoriesModel() {
        categoriesCell.append(MusicCategories.Rock)
        categoriesCell.append(MusicCategories.Pop)
        categoriesCell.append(MusicCategories.HipHop)
        categoriesCell.append(MusicCategories.RB)
        categoriesCell.append(MusicCategories.Electronic)
        categoriesCell.append(MusicCategories.Metal)
        categoriesCell.append(MusicCategories.Blues)
        categoriesCell.append(MusicCategories.Classic)
    }
    
    @objc func didTapSearchButton() {

        present(SearchViewController(), animated: true, completion: nil)
        print("did tap search")
    }
    
    
}

//MARK: - Collection View Extension

extension MusicCategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellToAnimate = collectionView.cellForItem(at: indexPath)
        cellToAnimate?.clickAnimate()
        
        let selection = categoriesCell[indexPath.row]
        
        switch selection {
        case .Blues:
            navigationController?.pushViewController(MusicGenrePostsViewController(with: selection), animated: true)
            break
        case .Rock:
            navigationController?.pushViewController(MusicGenrePostsViewController(with: selection), animated: true)
        case .Pop:
            navigationController?.pushViewController(MusicGenrePostsViewController(with: selection), animated: true)
        case .HipHop:
            navigationController?.pushViewController(MusicGenrePostsViewController(with: selection), animated: true)
        case .Electronic:
            navigationController?.pushViewController(MusicGenrePostsViewController(with: selection), animated: true)
            break
        case .RB:
            navigationController?.pushViewController(MusicGenrePostsViewController(with: selection), animated: true)
            break
        case .Classic:
            navigationController?.pushViewController(MusicGenrePostsViewController(with: selection), animated: true)
            break
        case .Metal:
            navigationController?.pushViewController(MusicGenrePostsViewController(with: selection), animated: true)
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let customCell = categoriesCell[indexPath.row]
        
        switch customCell {
        case .Blues:
            
            let viewModel = CategoriesViewModel(title: "Blues", thumbnailImage: UIImage(systemName: ""))
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as? CategoriesCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            }
            cell.backgroundColor = .systemBlue
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            
            cell.configure(with: viewModel)
            return cell
            
        case .Rock:
            
            let viewModel = CategoriesViewModel(title: "Rock", thumbnailImage: UIImage(systemName: ""))
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as? CategoriesCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            }
            cell.backgroundColor = .systemRed
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            
            cell.configure(with: viewModel)
            return cell
            
        case .Pop:
            
            let viewModel = CategoriesViewModel(title: "Pop", thumbnailImage: UIImage(systemName: ""))
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as? CategoriesCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            }
            cell.backgroundColor = .systemIndigo
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            
            cell.configure(with: viewModel)
            return cell
            
        case .HipHop:
            
            let viewModel = CategoriesViewModel(title: "HipHop", thumbnailImage: UIImage(systemName: ""))
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as? CategoriesCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            }
            cell.backgroundColor = .systemGreen
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            
            cell.configure(with: viewModel)
            return cell
            
        case .Electronic:
            
            let viewModel = CategoriesViewModel(title: "Electronic", thumbnailImage: UIImage(systemName: ""))
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as? CategoriesCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            }
            cell.backgroundColor = .orange
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            
            cell.configure(with: viewModel)
            return cell
            
        case .RB:
            
            let viewModel = CategoriesViewModel(title: "R&B", thumbnailImage: UIImage(systemName: ""))
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as? CategoriesCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            }
            cell.backgroundColor = .systemTeal
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            
            cell.configure(with: viewModel)
            return cell
            
        case .Classic:
            
            let viewModel = CategoriesViewModel(title: "Classic", thumbnailImage: UIImage(systemName: ""))
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as? CategoriesCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            }
            cell.backgroundColor = .systemGray6
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
    
            cell.configure(with: viewModel)
            return cell
            
        case .Metal:
            
            let viewModel = CategoriesViewModel(title: "Metal", thumbnailImage: UIImage(systemName: ""))
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as? CategoriesCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            }
            cell.backgroundColor = .darkGray
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            
            cell.configure(with: viewModel)
            return cell
            
        }

    }

}
extension MusicCategoriesViewController: TabItem {
    var tabImage: UIImage? {
        return UIImage(systemName: "music.note.list")
    }
    
    
}
//MARK: - SearchBar Extension

