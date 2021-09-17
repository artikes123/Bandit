//
//  PostModel.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 9.06.2021.
//

import Foundation

struct PostModel {
    
    var postURL: URL
    let user : User
    var fileName: String = ""
    var caption: String = ""
    var postGenre: String = ""
    var banditFileNames: [String]?
    var likedByCurrentUser = false
    
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...2 {
//            let post = PostModel(identifier: UUID().uuidString, user: User(userName: "drummer", profilePictureURL: nil, identifier: UUID().uuidString))
//            posts.append(post)
//        }
        }
        return posts
    }
    
    var videoChildPath: String {
        return "videos/\(postGenre)/\(user.userName.lowercased())"
    }
}
