//
//  NotificationsViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 8.06.2021.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    private let notificationLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Notifications"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
        
    }()
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(NotificationPostLikeTableViewCell.self, forCellReuseIdentifier: NotificationPostLikeTableViewCell.identifier)
        table.register(NotificationUserFollowTableViewCell.self, forCellReuseIdentifier: NotificationUserFollowTableViewCell.identifier)
        table.register(NotificationPostCommentTableViewCell.self, forCellReuseIdentifier: NotificationPostCommentTableViewCell.identifier)
        
        return table
        
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.tintColor = .label
        spinner.startAnimating()
        
        return spinner
    }()
    
    var notifications = [NotificationStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(notificationLabel)
        view.addSubview(tableView)
        view.addSubview(spinner)
        view.backgroundColor = .systemBackground
        
        fetchNotifications()
        
        //TableView'ın datayla düzenlendiği yerde pull to refresh aşağıdaki gibi yapılır
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = control
    }
    
    @objc func didPullToRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        //Refresh spinner hemen kapanmasın diye + 3 saniye ekledik async'e
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            DatabaseManager.shared.getNotifications { [weak self] notifications in
                self?.notifications = notifications
                self?.tableView.reloadData()
                sender.endRefreshing()
            }
            
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        notificationLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        notificationLabel.center = view.center
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    //MARK:  - Funcs
    
    func updateUI() {
        if notifications.isEmpty {
            notificationLabel.isHidden = false
            tableView.isHidden = true
        }
        else {
            notificationLabel.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
    
    
    
    func fetchNotifications() {
        DatabaseManager.shared.getNotifications {  [weak self] notifications in
            
            DispatchQueue.main.async {
                
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.notifications = notifications
                self?.updateUI()
                
            }
            
        }
    }
    
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = notifications[indexPath.row]
        //Case'lere göre cell'leri configure ediyoruz.
        switch model.type {
        
        case .postLike(let postName):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationPostLikeTableViewCell.identifier,
                                                           for: indexPath) as? NotificationPostLikeTableViewCell else {
                return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            }
            
            cell.delegate = self
            cell.configure(with: postName, model: model)
            return cell
            
            
        case .userFollow(let username):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationUserFollowTableViewCell.identifier,
                                                     for: indexPath) as? NotificationUserFollowTableViewCell else {
                return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            }
            
            cell.delegate = self
            cell.configure(with: username, model: model)
            return cell
            
            
        case .postComment(let postName):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationPostCommentTableViewCell.identifier,
                                                           for: indexPath) as? NotificationPostCommentTableViewCell else {
                
                return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            }
            cell.delegate = self
            cell.configure(with: postName, model: model)
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //Enable editing tableViewCells
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let model = notifications[indexPath.row]
        
        model.isHidden = true
        //model'de is hidden false olanları filtreleyerek gösteriyoruz

        
        DatabaseManager.shared.markNotificationAsHidden(notificationID: model.identifier) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    
                    self?.notifications = self?.notifications.filter({$0.isHidden == false}) ?? []
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                }
            }
          
        }
        
      
        
        
    }
    
}
//MARK: - notificationlardaki avatar ve follow button'a tıklandığı zaman ne olacağını belirliyoruz.

extension NotificationsViewController: NotificationUserFollowTableViewCellDelegate {
    
    func notificationUserFollowTableViewCellDelegate(_ cell: NotificationUserFollowTableViewCell, didTapFollowFor username: String) {
        DatabaseManager.shared.follow(username: username) { succcess in
            
            if !succcess {
                print("something while following from notification")
            }
            
            
            else {
                
            }
        }
    }
    
    func notificationUserFollowTableViewCellDelegate(_ cell: NotificationUserFollowTableViewCell, didTapAvatarFor username: String) {
        let vc = ProfileViewController(user: User(userName: username, profilePictureURL: nil, identifier: "123"))
        vc.title = username.uppercased()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension NotificationsViewController: NotificationPostLikeTableViewCellDelegate {
    func notificationPostLikeTableViewCellDelegate(_ cell: NotificationPostLikeTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
    }
}

extension NotificationsViewController: NotificationPostCommentTableViewCellDelegate {
    func notificationPostCommentTableViewCellDelegate(_ cell: NotificationPostCommentTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
    }

}

extension NotificationsViewController {
    func openPost(with identifier: String) {
        // Resolve post model from dataBase
        let vc = PostViewController(model: PostModel(postURL: URL(fileURLWithPath: ""), identifier: identifier, user: User(userName: "Kanye West", profilePictureURL: nil, identifier: UUID().uuidString)))
        vc.title = "video"
        navigationController?.pushViewController(vc, animated: true)
    }
}
