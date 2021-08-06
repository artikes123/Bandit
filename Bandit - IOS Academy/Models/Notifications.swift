//
//  Notifications.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 7.07.2021.
//

import Foundation

enum NotificationType {
    
    case postLike(postName: String )
    case userFollow(username: String )
    case postComment(postName: String )
    
    var id: String {
        
        switch self {
        
        case .postLike: return "postLike"
        case .userFollow: return "userFollow"
        case .postComment: return "postComment"
            
        }
        
    }
}

class NotificationStruct {
    
    let identifier = UUID().uuidString
    let text: String
    let date: Date
    let type: NotificationType
    var isHidden = false
    
    init(text:String, date:Date, type: NotificationType) {
        self.text = text
        self.date = date
        self.type = type
    }
    
    static func mockData() -> [NotificationStruct] {
        let postCommentArray = Array(0...3).compactMap({
            NotificationStruct(text: "Something Happend \($0)", date: Date(), type: .postComment(postName: "asdasdasd"))
        })
        let postLiketArray = Array(3...6).compactMap({
            NotificationStruct(text: "Something Happend \($0)", date: Date(), type: .postLike(postName: "asdasdasd"))
       })
        let postUserFollowArray = Array(6...9).compactMap({
            NotificationStruct(text: "Something Happend \($0)", date: Date(), type: .userFollow(username: "Artun"))
       })
        return postCommentArray + postLiketArray + postUserFollowArray
    }
}
