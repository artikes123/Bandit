//
//  ExploreHashtagViewModel.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 17.06.2021.
//

import Foundation
import UIKit

struct ExploreHashtagViewModel {
    let text: String
    let icon: UIImage?
    let count: Int? // Hashtag'de bulunan post sayısı
    let handler:(()->Void)
}
