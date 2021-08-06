//
//  MusicCategories.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 22.07.2021.
//

import Foundation

enum MusicCategories {
    case Rock
    case Pop
    case HipHop
    case Electronic
    case RB
    case Classic
    case Metal
    case Blues
    
    var title:String {
        switch self {
        case .Blues:
            return "Blues"
        case .Rock:
            return "Rock"
        case .Pop:
            return "Pop"
        case .HipHop:
            return "HipHop"
        case .Electronic:
            return "Electronic"
        case .RB:
            return "R&B"
        case .Classic:
            return "Classic"
        case .Metal:
            return "Metal"
        }
    }
    
}
