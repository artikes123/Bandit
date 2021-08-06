//
//  ExploreCell.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 17.06.2021.
//

import Foundation
import UIKit

enum ExploreCell {
    // Bütün farklı celL'leri burada tutuyoruz.
    
    // Bu cell'lerin her birine bir viewModel koyup cell'leri düzenleyeceğiz
    case banner(viewModel: ExploreBannerViewModel)
    case post(viewModel: ExplorePostViewModel)
    case hashtag(viewModel: ExploreHashtagViewModel)
    case user(viewModel: ExploreUserViewModel)
    
}




