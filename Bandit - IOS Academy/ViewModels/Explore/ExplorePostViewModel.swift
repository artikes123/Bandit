//
//  ExplorePostViewModel.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 17.06.2021.
//

import Foundation
import UIKit

struct ExplorePostViewModel {
    let thumbnailImage: UIImage?
    let caption: String
    let handler:(()->Void)
}
