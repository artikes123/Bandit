//
//  SignInViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 8.06.2021.
//

import UIKit
import SafariServices

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    public var completion: (() -> Void)?
    
    //    MARK:- Text Field Objects
    
    private let emailField = AuthField(type: .email)
    private let passwordField = AuthField(type: .password)
    
    //    MARK:- Auth Button Objects
    
    private let signInButton = AuthButton(type: .signIn, title: "Sign In")
    private let signUpButton = AuthButton(type: .plain, title: "New User? Create Account")
    private let forgotButton = AuthButton(type: .plain, title: "Forgot Password?")
    
    //MARK: -
    
    let logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "logo")
        logo.layer.cornerRadius = 10
        logo.layer.masksToBounds = true
        
        return logo
    }()
    
    
    
    //    MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign In"
        addSubviews()
        configureButtons()
        configureFields()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Ekran açılınca usernameFİeld tıklanmış olcak ve keyboard otomatik açılacak
        super.viewDidAppear(animated)

    }

    private func addSubviews(){
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(forgotButton)
    }
    
    private func configureButtons() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        forgotButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let imageSize : CGFloat = 100
        logoImageView.frame = CGRect(x: (view.width - imageSize)/2, y: view.safeAreaInsets.top + 5, width: imageSize, height: imageSize)
        
        
        emailField.frame = CGRect(x: 20, y: logoImageView.bottom + 20, width: view.width - 40, height: 45)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 20, width: view.width - 40, height: 45)
        
        signInButton.frame = CGRect(x: 20, y: passwordField.bottom + 35, width: view.width - 35, height: 42)
        forgotButton.frame = CGRect(x: 20, y: signInButton.bottom + 180, width: view.width - 35, height: 42)
        signUpButton.frame = CGRect(x: 20, y: forgotButton.bottom + 10, width: view.width - 35, height: 42)
        
    }
//    MARK: - Keyboard'da enter'a tıklandıktan sonra done olması & keyboard'un kapatılması vs
    func configureFields() {
        emailField.delegate = self
        passwordField.delegate = self
        
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolbar.sizeToFit()
        emailField.inputAccessoryView = toolbar
        passwordField.inputAccessoryView = toolbar
    }
    
    @objc func didTapKeyboardDone() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    //MARK: - Button action objc Funcs
    @objc func didTapSignIn() {
        
        didTapKeyboardDone()
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6
        
              else {
            let alert = UIAlertController(title: "Whoops", message: "Please enter valid Email and/or Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dissmis", style: .cancel, handler: nil))
            present(alert, animated: false, completion: nil)
            self.passwordField.text = nil
            return
        }
        
        AuthManager.shared.signIn(with: email, password: password) { loggedIn, databaseErrorMessage  in
            if loggedIn {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "Error", message: databaseErrorMessage , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

              
    }
    
    @objc func didTapSignUp() {
        let vc = SignUpViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapTerms() {
        didTapKeyboardDone()
        guard let url = URL(string: "https://www.tiktok.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: false, completion: nil)
    }
    
    
    
}
