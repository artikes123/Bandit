//
//  SearchViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 26.07.2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var tableView = UITableView()
    
    var profilImage: URL?
    
    var profileImageData: Data?
    
    var downloadProfilePictureCompleted: Bool?
    
    private var placeHolder = UILabel()
    
    private var userListArray = [String]()
    
    private var searchBar: UITextView = {
        
        var searchBar = UITextView()
        searchBar.layer.cornerRadius = 10
        searchBar.alpha = 1
        searchBar.autocapitalizationType = .none
        searchBar.returnKeyType = .done
        searchBar.isEditable = true
        
        
        return searchBar
    }()
    
    //    MARK: -Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        insertPlaceHolderToSearchBar()
        
        view.backgroundColor = .systemGray
        view.alpha = 0.9
        
        searchBar.becomeFirstResponder()
        //Cursor'ı en soldan başlatıyor
        searchBar.selectedTextRange = searchBar.textRange(from: searchBar.beginningOfDocument, to: searchBar.beginningOfDocument)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: view.safeAreaInsets.left + 5, y: view.top + 20, width: view.width - 10, height: 30)
        tableView.frame = CGRect(x: view.safeAreaInsets.left + 5, y: searchBar.bottom + 2, width: view.frame.width - 10, height: view.height - 80)
        
        tableView.layer.cornerRadius = 10
        
    }
    
    //MARK: - Funcs
    
    private func insertPlaceHolderToSearchBar() {
        //PlaceHolder
        placeHolder.text = "Search for a profile"
        placeHolder.textColor = .lightGray
        placeHolder.font = .italicSystemFont(ofSize: 15)
        placeHolder.frame = CGRect(x: 5, y: 5, width: searchBar.width, height: searchBar.height)
        placeHolder.sizeToFit()
        placeHolder.isHidden = !searchBar.text.isEmpty
        searchBar.addSubview(placeHolder)
    }
    
    private func configureViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(SearchUserTableViewCell.self, forCellReuseIdentifier: SearchUserTableViewCell().identifier)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchUserTableViewCell().identifier, for: indexPath) as? SearchUserTableViewCell else {
            print("error of search cell")
            return UITableViewCell()
        }
        
        if self.userListArray != [] {
            
            cell.username.text = self.userListArray[indexPath.row]
            
            downloadProfilePictureCompleted = false
            
            if self.downloadProfilePictureCompleted == false {
                
                StorageManager.shared.downloadProfilePicture(for: cell.username.text!) { profilePicture  in
                    
                    //URL to data
                    do {
                        guard let profilePicture = profilePicture else {
                            return
                        }
                        self.profileImageData = try Data(contentsOf: profilePicture)
                    }
                    catch {
                        print("Cant Convert donwloaded ProfilePicture to Data type")
                    }
                    // Data to Image
                    if let profileImageData = self.profileImageData {
                        let image = UIImage(data: profileImageData)
                        DispatchQueue.main.async {
                            cell.userImage.image = image
                            self.downloadProfilePictureCompleted = true
                        }
                        tableView.reloadData()
                        self.tableView = tableView
                        
                    }
                }
                
            }
        }
        
        else {
            cell.textLabel?.text = "There is no such User"
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchUserTableViewCell else {
            return
        }
        
        let selectedUser = cell.username.text
        
        if downloadProfilePictureCompleted == true {
            
            let vc = ProfileViewController(user: User(userName: selectedUser!, profilePictureURL: self.profilImage, identifier: "", instrument: ""))
            vc.modalPresentationStyle = .popover
            
            self.present(vc, animated: true, completion: nil)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        
    }
    
}

//MARK: - TEXT VIEW DELEGATE

extension SearchViewController: UITextViewDelegate {
    
    //Placeholder
    func textViewDidChange(_ textView: UITextView) {
        placeHolder.isHidden = !textView.text.isEmpty
    }
    
    //Pressed Return
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if self.userListArray != [] {
                self.userListArray.removeAll()
            }
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //Getting users from database
    func textViewDidEndEditing(_ textView: UITextView) {
        
        DatabaseManager.shared.getSearchedUsername(with: textView.text) { users in
            
            guard let users = users else {
                return
            }
            
            self.userListArray.append(contentsOf: users)
            self.tableView.reloadData()
        }
    }
}

