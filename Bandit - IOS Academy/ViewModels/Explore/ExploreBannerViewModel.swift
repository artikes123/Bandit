//
//  ExploreBannerViewModel.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 17.06.2021.
//

import Foundation
import UIKit

struct ExploreBannerViewModel {
    let imageView: UIImage?
    let title: String
    let handler:(()->Void)
}
