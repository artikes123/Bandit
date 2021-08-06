//
//  ExploreUserViewModel.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 17.06.2021.
//

import Foundation
import UIKit
 
struct ExploreUserViewModel {
    let userName: String
    let profilePicture: UIImage?
    let follower: Int?
    let handler:(()->Void)
}
