//
//  ExploreSectionType.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 17.06.2021.
//

import Foundation

enum ExploreSectionType: CaseIterable {
    case banners
    case trendingPosts
    case trendingHashtags
    case users
    case recommended
    case popular
    case new
    
    var title:String {
        switch self {
        
        case .users:
            return "Popular Creaters"
        case .banners:
            return "Feautred"
        case .trendingPosts:
            return "Trending Videos"
        case .trendingHashtags:
            return "Trending Hashtags"
        case .recommended:
            return "Recommended"
        case .popular:
            return "Popular"
        case .new:
            return "Recently Posted(New)"
        }
    }
    
}
