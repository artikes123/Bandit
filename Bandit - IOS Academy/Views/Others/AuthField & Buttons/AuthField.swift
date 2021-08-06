//
//  AuthField.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 25.06.2021.
//

import UIKit

class AuthField: UITextField {
    
    // BU field resuable olacağı için enum oluşturuyoruz
    
    enum FieldType {
        case email
        case username
        case password
        
        var title: String {
            switch self {
            case .email: return "Email adress"
            case .username: return "Username"
            case.password: return "Password"
            }
        }
        
        
    }
    
    private let type: FieldType
    
    init(type: FieldType) {
        self.type = type
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        autocapitalizationType = .none
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        placeholder = type.title

        returnKeyType = .done
        
        if type == .password {
            textContentType = .oneTimeCode
            isSecureTextEntry = true
        }
        else if type == .email {
            keyboardType = .emailAddress
            textContentType = .emailAddress
        }
    }
    
    

}
