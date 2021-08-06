//
//  HapticsManager.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 8.06.2021.
//

import Foundation
import UIKit

//Heptikler yani bazı durumlarda telefonuna titreşim sağlayacak manager.

final class HapticsManager {
    static let shared = HapticsManager()
    
    private init() {

        
    }
    
    //        Public
    
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
//    Error & Success vs gibi geri gelen bildirimlerde telefonun titremesi?
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
