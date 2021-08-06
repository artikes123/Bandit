//
//  AuthButton.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 25.06.2021.
//

import UIKit

class AuthButton: UIButton {
    
    enum ButtonType {
        case signIn
        case signUp
        case plain

        
        var title : String {
            switch self {
            
            case .signIn: return "Sign In"
            case .signUp: return "Sign Up"
            case .plain: return "-"
                
            }
        }
    }
    
    let type: ButtonType
    
    init(type: ButtonType, title: String?) {
        //Bu class!'tan obje oluşturulursa ve o obje init edilirse AuthButton(type: , title) gibi.. Bu durumda init edilen değerler class'ın içerisine geçmiş olur ve gerekli durumlara göre işlenir.
        self.type = type
        super.init(frame: .zero)
        if let title = title {
            setTitle(title, for: .normal)
        }
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        if type != .plain {
            setTitle(type.title, for: .normal)
        }
        setTitleColor(.white, for: .normal)
        switch type {
        case .signIn: backgroundColor = .systemBlue
        case .signUp: backgroundColor = .systemGreen
        case .plain: setTitleColor(.link, for: .normal)
                        backgroundColor = .clear
            
        }
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        layer.cornerRadius = 8
        layer.masksToBounds = true

    }
    
}
