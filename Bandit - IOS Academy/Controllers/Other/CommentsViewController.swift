//
//  CommentsViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 14.06.2021.
//

protocol CommentViewControllerDelegate:AnyObject {
    func didTapCloseForComments(with viewController: CommentsViewController)
}

import UIKit

class CommentsViewController: UIViewController {
    weak var delegate: CommentViewControllerDelegate?
    //MARK: - Variables
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentTableViewCell.self,
                           forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.backgroundColor = .lightGray
        return tableView
    }()
    
    var comments = [PostComment]()
    
    private let post : PostModel
    //MARK: -
    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        fetchPostComments()
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @objc func didTapClose() {
        delegate?.didTapCloseForComments(with: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 40, y: view.height * 0.05, width: 25, height: 25)
        tableView.frame = CGRect(x: 0, y: closeButton.bottom + 5, width: view.width, height: view.frame.height)
    }
    
    private func fetchPostComments() {
        self.comments = PostComment.mockComments()
    }
    
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
       guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier,for: indexPath) as? CommentTableViewCell else {
        return UITableViewCell()
       }
        cell.configure(with: comment)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
