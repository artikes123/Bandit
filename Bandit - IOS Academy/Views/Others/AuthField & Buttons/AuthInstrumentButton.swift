//
//  AuthInstrumentButton.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 28.06.2021.
//

import UIKit

class AuthInstrumentButton: UIButton {
    
    enum InsturmentType {
        case drum
        case guitar
        case horn
        case piano
        case violin
        
        var selectedInstrument : String? {
            switch self {
            case .drum: return "drum"
            case .guitar: return "guitar"
            case .horn: return "horn"
            case .piano: return "piano"
            case .violin: return "violin"
                
            }
        }
    }
    
    let instrumentType: InsturmentType
    
    init(type: InsturmentType, image: UIImage?) {
        self.instrumentType = type
        super.init(frame: .zero)
        if let _ = image {
            setImage(image, for: .normal)
        }
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    
    func configureUI() {
        contentMode = .scaleAspectFit
        backgroundColor = .systemYellow
        layer.cornerRadius = 22
        layer.masksToBounds = true
        clipsToBounds = true
        
    }
}


