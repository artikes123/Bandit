//
//  ExploreManager.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 21.06.2021.
//

import Foundation
import UIKit

protocol ExploreManagerDelegate: AnyObject {
    func pushViewController(_ vc: UIViewController)
    func didTapHashtag(_ hashtag: String)
}

final class ExploreManager {
    static let shared = ExploreManager()
     
    weak var delegate: ExploreManagerDelegate?
    
    enum BannerAction: String {
        case post
        case hashtag
        case user
    }
    
    //MARK: - Getting Explore Data
    
    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.banners.compactMap({ model in
            
            ExploreBannerViewModel(
                imageView: UIImage(named: model.image),
                title: model.title) {
                [weak self] in
                //Handler içerisine Banner'a tıklandığı zaman ne olacağını seçiyoruz. Banner'ları 3 tane aksiyonu var json datasında.(user post ve hashtag) bu yüzden 3 case üzerinde farklı aksiyon senaryoları çalışacağız.

                guard let action = BannerAction(rawValue: model.action) else {
                    print("action error")
                    return
                }
                
                DispatchQueue.main.async {
                    let vc = UIViewController()
                    vc.view.backgroundColor = .red
                    vc.title = action.rawValue.uppercased()
                    self?.delegate?.pushViewController(vc)
                }
                    
                switch action {
                
                case .user:
                    //Profile
                break
                case .post:
                //Post
                break
                case .hashtag:
                //hashtag
                break
                
                
                }
                
            }
        })
    }
    
    public func getExploreUsers() -> [ExploreUserViewModel] {
        guard let exploreData = parseExploreData() else {

            return []
        }

        return exploreData.creators.compactMap({ model in
            ExploreUserViewModel(userName: model.username, profilePicture: UIImage(named: model.image), follower: model.followers_count) { [weak self] in
                DispatchQueue.main.async {
                    let userID = model.id
                    let vc = ProfileViewController(user: User(userName: "Joe", profilePictureURL: nil, identifier: userID, instrument: ""))
                    self?.delegate?.pushViewController(vc)
                }
               
                
            }
        })

    }
    
    public func getExplorePopularPosts() /* -> [ExplorePostViewModel] */ {
//        guard let exploreData = parseExploreData() else {
//
//            return []
//        }
//
//        return exploreData.popular.compactMap({ model in
//            ExplorePostViewModel(thumbnailImage: UIImage(named: model.image), caption: model.caption) {
//                [weak self] in
//                DispatchQueue.main.async {
//                    let postID = model.id
//                    let vc = PostViewController(model: PostModel(identifier: postID, user: User(userName: "Kanye West", profilePictureURL: nil, identifier: UUID().uuidString)))
//                    self?.delegate?.pushViewController(vc)
//                }
//
//            }
//
//        })

    }
    
    public func getExploreRecentPosts() /*-> [ExplorePostViewModel] */{
//        guard let exploreData = parseExploreData() else {
//
//            return []
//        }
//
//        return exploreData.recentPosts.compactMap({ model in
//            ExplorePostViewModel(thumbnailImage: UIImage(named: model.image), caption: model.caption) { [weak self] in
//
//                DispatchQueue.main.async {
//                    let postID = model.id
//                    let vc = PostViewController(model: PostModel(identifier: postID, user: User(userName: "Kanye West", profilePictureURL: nil, identifier: UUID().uuidString)))
//                    self?.delegate?.pushViewController(vc)
//                }
//
//            }
//
//        })

    }
    
    public func getExploreTrendingPosts() /*-> [ExplorePostViewModel] */{
//        guard let exploreData = parseExploreData() else {
//            return []
//        }
//
//
//
//        return exploreData.trendingPosts.compactMap({ model in
//            ExplorePostViewModel(thumbnailImage: UIImage(named: model.image), caption: model.caption) { [weak self] in
//                DispatchQueue.main.async {
//                    let postID = model.id
//                    let vc = PostViewController(model: PostModel(identifier: postID, user: User(userName: "Kanye West", profilePictureURL: nil, identifier: UUID().uuidString)))
//                    self?.delegate?.pushViewController(vc)
//                }
//
//
//            }
//
//        })

    }
    

    
    public func getExploreHashtags() -> [ExploreHashtagViewModel] {
        guard let exploreData = parseExploreData() else {

            return []
        }

        return exploreData.hashtags.compactMap({ model in
            ExploreHashtagViewModel(text: "#" + model.tag, icon: UIImage(systemName: model.image), count: model.count) { [weak self] in
                DispatchQueue.main.async {
                    self?.delegate?.didTapHashtag(model.tag)
                }

            }
        })

    }
    
    //MARK: -
    
    //Json dosyasını parslayıp model olarak kaydedecek
    private func parseExploreData() -> ExploreResponse? {
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else {

            return nil
        }
        do {
            let url = URL(fileURLWithPath: path) //JSON dosyasını url'ye çevirdik
            let data = try Data(contentsOf: url) // JSon dosyasının urlsinde bulunan verileri data olarak kaydetttik.
            return try JSONDecoder().decode(ExploreResponse.self, from: data) // Explore response içerisindekilerden birini decode etmeye çalışıyor.
        }
        catch {
            print("Explore error is \(error)")
            return nil
        }

    }
}

struct ExploreResponse: Codable {
    //Decode edeceğimiz JSon formatındaki her şeyle aynı isimlerde parametreler oluşturuyoruz.
    // Codable : Decodable & encodable
    let banners: [Banner]
    let trendingPosts: [Post]
    let creators: [Creator]
    let recentPosts: [Post]
    let hashtags: [Hashtag]
    let popular: [Post]
    let recommended: [Post]
}

struct Banner: Codable {
    let id: String
    let image: String
    let title: String
    let action: String
}

struct Post: Codable {
    let id: String
    let image: String
    let caption: String
}

struct Hashtag: Codable {
    let image: String
    let tag : String
    let count : Int
}

struct Creator: Codable {
    let id: String
    let image: String
    let username : String
    let followers_count: Int
}


