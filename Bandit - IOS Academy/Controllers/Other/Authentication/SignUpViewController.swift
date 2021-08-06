//
//  SignUpViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 8.06.2021.
//

import UIKit
import SafariServices
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    public var completion: (() -> Void)?
    
    public var instrument : String? = "Only Listener"
    
    private var isAnyInstrumentSelected: Bool!
    
    //    MARK:- Text Field Objects
    
    private let emailField = AuthField(type: .email)
    private let username = AuthField(type: .username)
    private let passwordField = AuthField(type: .password)
    
    //    MARK:- Auth Button Objects
    
    private let signUpButton = AuthButton(type: .signUp, title: "New User? Create Account")
    private let termsOfServiceButton = AuthButton(type: .plain, title: "Terms of Service")
    
    //MARK: - Insturment Button Objects
    
    private let drumButton = AuthInstrumentButton(type: .drum, image: UIImage(named: "drum"))
    private let guitarButton = AuthInstrumentButton(type: .guitar, image: UIImage(named: "guitar"))
    private let hornButton = AuthInstrumentButton(type: .horn, image: UIImage(named: "horn"))
    private let pianoButton = AuthInstrumentButton(type: .piano, image: UIImage(named: "piano"))
    private let violinButton = AuthInstrumentButton(type: .violin, image: UIImage(named: "violin"))
    
    
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
        title = "Sign Up"
        addSubviews()
        configureButtons()
        configureFields()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Ekran açılınca usernameFİeld tıklanmış olcak ve keyboard otomatik açılacak
        super.viewDidAppear(animated)
        username.becomeFirstResponder()
    }
    
    private func addSubviews(){
        
        view.addSubview(logoImageView)
        
        view.addSubview(emailField)
        view.addSubview(username)
        view.addSubview(passwordField)
        
        view.addSubview(signUpButton)
        view.addSubview(termsOfServiceButton)
        
        view.addSubview(drumButton)
        view.addSubview(guitarButton)
        view.addSubview(hornButton)
        view.addSubview(pianoButton)
        view.addSubview(violinButton)
    }
    
    private func configureButtons() {
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        termsOfServiceButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        
        drumButton.addTarget(self, action: #selector(didTapDrum), for: .touchUpInside)
        guitarButton.addTarget(self, action: #selector(didTapGuitar), for: .touchUpInside)
        hornButton.addTarget(self, action: #selector(didTaphorn), for: .touchUpInside)
        pianoButton.addTarget(self, action: #selector(didTapPiano), for: .touchUpInside)
        violinButton.addTarget(self, action: #selector(didTapViolin), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let imageSize : CGFloat = 100
        logoImageView.frame = CGRect(x: (view.width - imageSize)/2, y: view.safeAreaInsets.top + 5, width: imageSize, height: imageSize)
        
        
        username.frame = CGRect(x: 20, y: logoImageView.bottom + 80, width: view.width - 40, height: 45)
        emailField.frame = CGRect(x: 20, y: username.bottom + 20, width: view.width - 40, height: 45)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 20, width: view.width - 40, height: 45)
        
        
        signUpButton.frame = CGRect(x: 20, y: passwordField.bottom + 80, width: view.width - 35, height: 42)
        termsOfServiceButton.frame = CGRect(x: 20, y: view.bottom - 80, width: view.width - 35, height: 42)
        
        
        let instrumentSize : CGFloat = 44
        drumButton.frame = CGRect(x: 20, y: username.top - 20 - 35, width: instrumentSize, height: instrumentSize)
        guitarButton.frame = CGRect(x: drumButton.frame.maxX + 10, y: username.top - 20 - 35, width: instrumentSize, height: instrumentSize)
        hornButton.frame = CGRect(x: guitarButton.frame.maxX + 10, y: username.top - 20 - 35, width: instrumentSize, height: instrumentSize)
        pianoButton.frame = CGRect(x: hornButton.frame.maxX + 10, y: username.top - 20 - 35, width: instrumentSize, height: instrumentSize)
        violinButton.frame = CGRect(x: pianoButton.frame.maxX + 10, y: username.top - 20 - 35, width: instrumentSize, height: instrumentSize)
        
    }
    //    MARK: - Keyboard'da enter'a tıklandıktan sonra done olması & keyboard'un kapatılması vs
    func configureFields() {
        emailField.delegate = self
        passwordField.delegate = self
        username.delegate = self
        
        username.autocorrectionType = .no
        username.autocapitalizationType = .none
    
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
        username.inputAccessoryView = toolbar
    }
    
    @objc func didTapKeyboardDone() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        username.resignFirstResponder()
    }
   
    //MARK: - Selected Insturment Buttons objc funcs
    
    @objc func didTapDrum() {
        
        guard var selectedInstrument = drumButton.instrumentType.selectedInstrument else {
            return
        }
        
        //enstrüman seçilmediyse diğer butonlar enable
        if drumButton.isSelected == true {
        
            guitarButton.isEnabled = true
            hornButton.isEnabled = true
            pianoButton.isEnabled = true
            violinButton.isEnabled = true
            
            drumButton.backgroundColor = .systemYellow
            drumButton.isSelected = false
            drumButton.isHighlighted = false
            selectedInstrument = "Only Listener"
        }
        // enstrüman seçildiyse diğerleri disable
        
        else {
            
            guitarButton.isEnabled = false
            hornButton.isEnabled = false
            pianoButton.isEnabled = false
            violinButton.isEnabled = false
            
            drumButton.backgroundColor = .systemBlue
            drumButton.isHighlighted = true
            drumButton.isSelected = true

            
        }
        
        self.instrument = selectedInstrument
    }
    
    @objc func didTapGuitar() {
        guard var selectedInstrument = guitarButton.instrumentType.selectedInstrument else {
            return
        }
        
        //enstrüman seçilmediyse diğer butonlar enable
        if guitarButton.isSelected == true {
        
            drumButton.isEnabled = true
            hornButton.isEnabled = true
            pianoButton.isEnabled = true
            violinButton.isEnabled = true
            
            guitarButton.backgroundColor = .systemYellow
            guitarButton.isSelected = false
            guitarButton.isHighlighted = false
            selectedInstrument = "Only Listener"
        }
        // enstrüman seçildiyse diğerleri disable
        
        else {
        
            drumButton.isEnabled = false
            hornButton.isEnabled = false
            pianoButton.isEnabled = false
            violinButton.isEnabled = false
            
            guitarButton.backgroundColor = .systemBlue
            guitarButton.isHighlighted = true
            guitarButton.isSelected = true

        }
        
        self.instrument = selectedInstrument
    }
    
    @objc func didTaphorn() {
        guard var selectedInstrument = hornButton.instrumentType.selectedInstrument else {
            return
        }
        
        //enstrüman seçilmediyse diğer butonlar enable
        if hornButton.isSelected == true {
        
            guitarButton.isEnabled = true
            drumButton.isEnabled = true
            pianoButton.isEnabled = true
            violinButton.isEnabled = true
            
            hornButton.backgroundColor = .systemYellow
            hornButton.isSelected = false
            hornButton.isHighlighted = false
            
            selectedInstrument = "Only Listener"
        }
        // enstrüman seçildiyse diğerleri disable
        
        else {
            
            guitarButton.isEnabled = false
            drumButton.isEnabled = false
            pianoButton.isEnabled = false
            violinButton.isEnabled = false
            
            hornButton.backgroundColor = .systemBlue
            hornButton.isHighlighted = true
            hornButton.isSelected = true

        }
        
        self.instrument = selectedInstrument
    }
    
    @objc func didTapPiano() {
        guard var selectedInstrument = pianoButton.instrumentType.selectedInstrument else {
            return
        }
        
        //enstrüman seçilmediyse diğer butonlar enable
        if pianoButton.isSelected == true {
        
            guitarButton.isEnabled = true
            hornButton.isEnabled = true
            drumButton.isEnabled = true
            violinButton.isEnabled = true
            
            pianoButton.backgroundColor = .systemYellow
            pianoButton.isSelected = false
            pianoButton.isHighlighted = false
            
            selectedInstrument = "Only Listener"
        }
        // enstrüman seçildiyse diğerleri disable
        
        else {
            
            guitarButton.isEnabled = false
            hornButton.isEnabled = false
            drumButton.isEnabled = false
            violinButton.isEnabled = false
            
            pianoButton.backgroundColor = .systemBlue
            pianoButton.isHighlighted = true
            pianoButton.isSelected = true
            
        }
        
        self.instrument = selectedInstrument
    }
    
    @objc func didTapViolin() {
        guard var selectedInstrument = violinButton.instrumentType.selectedInstrument else {
            return
        }
        //enstrüman seçilmediyse diğer butonlar enable
        if violinButton.isSelected == true {
        
            guitarButton.isEnabled = true
            hornButton.isEnabled = true
            pianoButton.isEnabled = true
            drumButton.isEnabled = true
            
            violinButton.backgroundColor = .systemYellow
            violinButton.isSelected = false
            violinButton.isHighlighted = false
            
            selectedInstrument = "Only Listener"
        }
        // enstrüman seçildiyse diğerleri disable
        
        else {
            
            guitarButton.isEnabled = false
            hornButton.isEnabled = false
            pianoButton.isEnabled = false
            drumButton.isEnabled = false
            
            violinButton.backgroundColor = .systemBlue
            violinButton.isHighlighted = true
            violinButton.isSelected = true
            
        }
        
        self.instrument = selectedInstrument
    }
    
    //MARK: - Auth Button action objc Funcs
    
    @objc func didTapSignUp() {
        
        guard let email = emailField.text,
              let password = passwordField.text,
              let username = username.text,
              let instrument = instrument,
        
              //Text Fieldlarda boşluk olursa bu kod bloğu çalışmayacak
              
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6,
              !username.contains(" "),
              !username.contains("."),
              email.contains("@")
        
        else {
            let alert = UIAlertController(title: "Whoops", message: "Your Password must be 6 characters long. Try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dissmis", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        AuthManager.shared.signUp(with: email, password: password, username: username, instrument: instrument) { (success, error) in
            if !success {
                let databaseAlert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertController.Style.alert)
                databaseAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(databaseAlert, animated: true, completion: nil)
            }
            else {
                self.dismiss(animated: true, completion: nil)
            }
        }
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
