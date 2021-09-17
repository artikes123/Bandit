//
//  PostComment.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 14.06.2021.
//

import Foundation

struct PostComment {
    
    let text: String
    let user: User
    let date: Date
    
    static func mockComments() -> [PostComment] {
        let user = User(userName: "Artun Erol",
                        profilePictureURL: nil,
                        identifier: UUID().uuidString, instrument: "")
        
        var comments = [PostComment]()
        
        let text = [
            "Great Post",
            "Lovely Post",
            "Incredible Post"
        ]
        
        for comment in text {
            comments.append(PostComment(text: comment,
                                        user: user,
                                        date: Date()))
        }
       return comments
    }
}
