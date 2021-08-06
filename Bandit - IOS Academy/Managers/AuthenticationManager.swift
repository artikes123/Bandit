//
//  AuthenticationManager.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 8.06.2021.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
   public static let shared = AuthManager()
    
    private init() {

    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    enum SignInMethod {
        
    case email
        
    }
    
    
    
//    Public
//MARK: - SignIn && SignOut functions
    
    public func signIn(with email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                completion(false, error?.localizedDescription)
            }
            else {
                //Kullanıcı sign in olunca email'i dışında onun username'ini de getiriyoruz.
                DatabaseManager.shared.getUsername(with: email) { (username) in
                    if let username = username  {
                        UserDefaults.standard.setValue(username, forKey: "username")
                        completion(true, "")
                    }

                }
                
            }
        }
        
      
    }
    
    public func signUp(with email: String, password: String, username: String, instrument: String, completion: @escaping (Bool, String?) -> Void ) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, createUserError) in
            if createUserError != nil {
                completion(false, createUserError?.localizedDescription)
            }
            else {
                completion(true, "")
                
                UserDefaults.standard.setValue(username, forKey: "username")

                DatabaseManager.shared.insertUsers(with: email, username: username, instrument: instrument) { (success) in
                    
                }
            }
            
        }
    }
    
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        }
        catch {
            print("Singout Failed")
            completion(false)
        }
           }
    
    
    
    
}
