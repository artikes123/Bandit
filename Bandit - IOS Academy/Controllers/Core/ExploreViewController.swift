//
//  ExploreViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 8.06.2021.
//

import UIKit
import AMTabView
 
class ExploreViewController: UIViewController {
    
    //MARK: - SearchBar
    
    private let searchBar : UISearchBar = {
       let bar = UISearchBar()
        
        bar.placeholder = "Search..."
        bar.layer.cornerRadius = 8
        bar.layer.masksToBounds = true
        
        return bar
    }()
    
    //MARK: - Objects
    private var sections = [ExploreSection]()
    
    private var collectionView : UICollectionView?

    //MARK: - Did Load & LayoudSubviews
    override func viewDidLoad() {
        super.viewDidLoad()
        ExploreManager.shared.delegate = self
        configureModels()
        setUpCollectionView()
        view.backgroundColor = .systemBackground
        setUpSearchBar()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    //MARK: - Configure Models
    
    private func configureModels() {
     
//        // Banners
//        sections.append(
//            ExploreSection(
//                type: .banners,
//                cells: ExploreManager.shared.getExploreBanners().compactMap({
//
//                    return ExploreCell.banner(viewModel: $0)
//                })
//            ))
//
//         // Trending Post
//         sections.append(
//             ExploreSection(
//                 type: .trendingPosts,
//                cells: ExploreManager.shared.getExploreTrendingPosts().compactMap({
//                    return ExploreCell.post(viewModel: $0)
//                }))
//            )
//         //Users
//         sections.append(
//             ExploreSection(
//                 type: .users,
//                cells: ExploreManager.shared.getExploreUsers().compactMap({
//                    return ExploreCell.user(viewModel: $0)
//                })
//             ))
//         //Trending Hashtags
//         sections.append(
//             ExploreSection(
//                 type: .trendingHashtags,
//                cells: ExploreManager.shared.getExploreHashtags().compactMap({
//                    return ExploreCell.hashtag(viewModel: $0)
//                })
//             ))
//
//         //Popular
//         sections.append(
//             ExploreSection(
//                 type: .popular,
//                cells: ExploreManager.shared.getExplorePopularPosts().compactMap({
//                    return ExploreCell.post(viewModel: $0)
//                })
//             ))
//         //New
//         sections.append(
//             ExploreSection(
//                 type: .new,
//                cells: ExploreManager.shared.getExploreRecentPosts().compactMap({
//                    return ExploreCell.post(viewModel: $0)
//                })
//             ))
     }
    
    //MARK: - Setting Up collectionView
    
    func setUpCollectionView() {
        
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            //CollectionView'ın her section'ının layout'u oluşturuluyor.
            return self.layout(for: section)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) // Collection View'ın layout'u olduğunu belirtiyoruz.

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.register(ExploreBannerCollectionViewCell.self, forCellWithReuseIdentifier: ExploreBannerCollectionViewCell.identifier)
        collectionView.register(ExplorePostCollectionViewCell.self, forCellWithReuseIdentifier: ExplorePostCollectionViewCell.identifier)
        collectionView.register(ExploreUserCollectionViewCell.self, forCellWithReuseIdentifier: ExploreUserCollectionViewCell.identifier)
        collectionView.register(ExploreHashtagCollectionViewCell.self, forCellWithReuseIdentifier: ExploreHashtagCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground

        view.addSubview(collectionView)
        self.collectionView = collectionView
        
        

    }
    
    func setUpSearchBar() {
        navigationItem.titleView = searchBar // title'da ne gözükeceğini belirliyoruz
        searchBar.delegate = self
    }
}

//MARK: - CollectionView Delegate & DataSource

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        
        // Cell'leri collectionView'a atıyoruz.
        case .banner(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreBannerCollectionViewCell.identifier, for: indexPath) as? ExploreBannerCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            }
            cell.configure(with: viewModel)
            return cell
            
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExplorePostCollectionViewCell.identifier, for: indexPath) as? ExplorePostCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            }
            cell.configure(with: viewModel)
            return cell
            
        case .hashtag(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreHashtagCollectionViewCell.identifier, for: indexPath) as? ExploreHashtagCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            }
            cell.configure(with: viewModel)
            return cell
            
            
        case .user(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreUserCollectionViewCell.identifier, for: indexPath) as? ExploreUserCollectionViewCell else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            }
            cell.configure(with: viewModel)
            return cell
        }
        
    }
    //MARK: - collectionView DidselectRow at
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        
        // Cell'leri collectionView'a atıyoruz.
        case .banner(let viewModel):
            viewModel.handler()
            break
            
        case .post(let viewModel):
            viewModel.handler()
            break
            
        case .hashtag(let viewModel):
            viewModel.handler()
            break
            
        case .user(let viewModel):
            break
        }
        
    }
    
}

//MARK: - SearchBardelegate

extension ExploreViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
    }
    
    @objc func didTapCancel() {
        navigationItem.rightBarButtonItem = nil
        searchBar.text = nil
        searchBar.resignFirstResponder() //keyboard'u ortadan kaldırıyor
        
    }
    //Keyboard'un ortadan kalkması
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Layout
extension ExploreViewController {
    func layout(for section: Int) -> NSCollectionLayoutSection {
        // Her section için layout oluşturuyor ve onu return ediyor.
        let sectionType = sections[section].type
        
        switch sectionType {
        
        case .banners:
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 4 , leading: 4, bottom: 4, trailing: 4) // Her item'ın bir diğeriyle arasındaki boşluk ayarlanıyor
            
            // Group -- Item'ların nasıl dizileceğini ve section içerisinde nasıl bulunacaklarını belirtiyor
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalHeight(0.5),
                    heightDimension: .absolute(200)),
                subitems: [item])
            
            
            
            //section -- Section ise genellikle birbirlerinden farklı olan ögeleri ayırmak için kullanılıyor. Mesela photos app'teki yıllar ve ayların ayrımı gibi
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            // Return
            return sectionLayout
            
        case .users:
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 1 , leading: 4, bottom: 4, trailing: 4) // Her item'ın bir diğeriyle arasındaki boşluk ayarlanıyor
            
            // Group -- Item'ların nasıl dizileceğini ve section içerisinde nasıl bulunacaklarını belirtiyor
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(200)),
                subitems: [item])
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(210), heightDimension: .absolute(240)),
                subitems: [verticalGroup])
            
            
            
            //section -- Section ise genellikle birbirlerinden farklı olan ögeleri ayırmak için kullanılıyor. Mesela photos app'teki yıllar ve ayların ayrımı gibi
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            // Return
            return sectionLayout
           
        case .trendingHashtags:
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 4 , leading: 4, bottom: 2, trailing: 4) // Her item'ın bir diğeriyle arasındaki boşluk ayarlanıyor
            
            // Group -- Item'ların nasıl dizileceğini ve section içerisinde nasıl bulunacaklarını belirtiyor
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(130)),
                subitem: item, count: 4)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180)),
                subitems: [verticalGroup])
            
            
            
            //section -- Section ise genellikle birbirlerinden farklı olan ögeleri ayırmak için kullanılıyor. Mesela photos app'teki yıllar ve ayların ayrımı gibi
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            // Return
            return sectionLayout

        case .trendingPosts, .popular, .recommended,.new:
            // Item
            // Item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 4 , leading: 4, bottom: 4, trailing: 4) // Her item'ın bir diğeriyle arasındaki boşluk ayarlanıyor
            
            // Group -- Item'ların nasıl dizileceğini ve section içerisinde nasıl bulunacaklarını belirtiyor
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(300)),
                subitem: item, count: 2
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(300)),
                subitems: [verticalGroup])
            
            
            //section -- Section ise genellikle birbirlerinden farklı olan ögeleri ayırmak için kullanılıyor. Mesela photos app'teki yıllar ve ayların ayrımı gibi
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            // Return
            return sectionLayout
      
        }
       
    }
}

extension ExploreViewController: ExploreManagerDelegate {
    // delegate içerisindeki fonksiyonun ne işe yaradığını Explore VC'de belirtiyoruz. 
    func pushViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    func didTapHashtag(_ hashtag: String) {
        searchBar.text = hashtag
        searchBar.becomeFirstResponder()
    }
    
     
}

