//
//  PostViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 8.06.2021.
//

import UIKit
import AVFoundation


protocol PostViewControllerDelegate: AnyObject {
    func postViewController(_vc: PostViewController, didTapCommentButtonFor: PostModel)
    func postViewController(_vc: PostViewController, didTapProfileButtonFor: PostModel)
    func postViewController(_vc: PostViewController, didTapBanditButtonFor: PostModel)
}

class PostViewController: UIViewController {
    
    weak var delegate: PostViewControllerDelegate?
    
    
    var model: PostModel
    var isPostInMusicGenre = false
    
    //  MARK: - Buttonların obje olarak oluşturulması
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let backButton : UIButton = {
        let button = UIButton()
        button.largeContentImage = UIImage(systemName: "arrowshape.turn.up.backward")
        button.setImage(UIImage(systemName: "arrowshape.turn.up.backward"), for: .normal)
        
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let banditButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "logo"), for: .normal)
        
        return button
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22)
        label.numberOfLines = 0
        label.text = "Check Out Bandit!! Check Out Bandit!!"
        return label
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "Test"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = "Username"
        label.font = UIFont(name: "MarkerFelt-Thin", size: 18)
        
        return label
    }()
    
    private let profileButtonAndUsernameView : UIView = {
        let view = UIView()
        
        return view
    }()
    
    var player: AVPlayer?
    
    private let videoView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        
        return view
    }()
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        return spinner
    }()
    
    private var playerDidFinishOberserver: NSObjectProtocol? // Kullanıcı videoyu bitirdikten sonra ne olacağını belirliyoruz
    
    //    MARK: - Init
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    init(model: PostModel, isPostInMusicGenre: Bool) {
        self.model = model
        self.isPostInMusicGenre = isPostInMusicGenre
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideo(with: model)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(spinner)
        view.addSubview(videoView)
        view.addSubview(captionLabel)
        
        view.backgroundColor = .black
        view.frame = CGRect(x: 0, y: 0, width: view.width, height: 200)
        
        setUpButtons()
        setUpDoubleTapToLike()
        
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() { // Subview'ların konumlarını vs (CGRECT) ayarlıyoruz.
        super.viewDidLayoutSubviews()
        let size : CGFloat = 45
        let labelSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 10, height: view.height)) // Comment'in belirlenen alana sığması gerektiğini belirtiyoruz.
        
        videoView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height - view.safeAreaInsets.bottom)
        videoView.layer.cornerRadius = 20
        videoView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] //Corner mask to top right and left
        videoView.backgroundColor = .secondarySystemBackground
        
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
        
        //Caption Label
        captionLabel.sizeToFit()
        captionLabel.frame = CGRect(x: 5,
                                    y: videoView.bottom - labelSize.height - 5,
                                    width: view.width - size - 12,
                                    height: labelSize.height)
        
        banditButton.frame = CGRect(x: view.width - 50, y: view.safeAreaInsets.top + 10, width: size, height: size)
        profileButton.layer.cornerRadius = 25
        profileButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        usernameLabel.frame = CGRect(x: profileButton.right + 5, y: profileButton.top + 5, width: view.width - 100, height: 45)
        
        if isPostInMusicGenre {
            profileButtonAndUsernameView.frame = CGRect(x: view.width/4, y: view.safeAreaInsets.top + 10, width: view.width - banditButton.left, height: 50)
            backButton.isHidden = false
            backButton.tintColor = .yellow
            backButton.frame = CGRect(x: view.left + 5, y: view.safeAreaInsets.top + 10, width: 45, height: 45)
        }
        else {
            profileButtonAndUsernameView.frame = CGRect(x: view.left + 5, y: view.safeAreaInsets.top + 10, width: view.width - banditButton.left, height: 50)
        }

 
        //MARK: - Buttonların CGRect setup
        let yStart: CGFloat = view.height - (size * 4) - view.safeAreaInsets.bottom
        for (index, button) in [likeButton,commentButton,shareButton].enumerated() {
            button.frame = CGRect(x: view.width - size - 10, y: yStart + (CGFloat(index) * size) + 10,  width: size, height: size)
        }
        
    }
    
    //    MARK: - Setting UP  buttons
    
    func setUpButtons() {
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)
        view.addSubview(banditButton)
        view.addSubview(profileButton)
        view.addSubview(backButton)
        
        backButton.isHidden = true
        
        usernameLabel.text = model.user.userName
        profileButtonAndUsernameView.addSubview(usernameLabel)
        profileButtonAndUsernameView.addSubview(profileButton)
        
        view.addSubview(profileButtonAndUsernameView)
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        banditButton.addTarget(self, action: #selector(didTapBandit), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        
        if let profilePictureURL = model.user.profilePictureURL {
            do {
                let imageData = try Data(contentsOf: profilePictureURL)
                let image = UIImage(data: imageData)
                profileButton.setBackgroundImage(image, for: .normal)
            }
            catch {
                print("cant convert profile picture data to image in Post VC")
            }
        }
        else {
            profileButton.setBackgroundImage(UIImage(named: "Test"), for: .normal)
        }
        
 
        
    }
    
    //MARK: - Configure Video
    
    private func configureVideo(with model: PostModel) {
        
        // Video path'i URL'ye çevirdik
        player = AVPlayer(url: model.postURL) // Vİdeo'yu player'a atmak
        
        let playerLayer1 = AVPlayerLayer(player: player) //Video'yu ekranda gösterebilmek için onu AVPLayer layer'a dönüştürüyoruz
        playerLayer1.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        playerLayer1.videoGravity = .resizeAspectFill
        
        player?.volume = 0
        videoView.layer.addSublayer(playerLayer1)
        
        player?.play()
        
        // Video bittikten sonra video resetlenmesi
        guard let player = player else {
            return
        }
        
        playerDidFinishOberserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                                           object: player.currentItem,
                                                                           queue: .main) { _ in
            self.player?.seek(to: .zero)
            player.play()
            
            
        }
        
    }

    //    MARK: - Like Comment Share Buttonlarının selector functions OBJc
    
    @objc private func didTapLike() {
        model.likedByCurrentUser = !model.likedByCurrentUser
        
        likeButton.tintColor = model.likedByCurrentUser ? .systemRed : .white // eğer likebycurrentuser true is system red yoksa white yap
    }
    
    @objc private func didTapComment() {
        delegate?.postViewController(_vc: self, didTapCommentButtonFor: model)
    }
    
    @objc private func didTapShare() {
        
        guard let url = URL(string: "https://www.tiktok.com") else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [url],  // ActibityVC, URL paylaşmakta kullanılan VC
                                          applicationActivities: [])
        present(vc, animated: false)
        
    }
    
    @objc func didTapProfileButton() {
        delegate?.postViewController(_vc: self, didTapProfileButtonFor: model)
    }
    
    @objc func didTapBandit() {
        let alert = UIAlertController()
        print("model url in postVC is \(model.postURL)")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Show Bandits", style: .default, handler: { (_) in
            
        }))
        alert.addAction(UIAlertAction(title: "Capture Bandit Video", style: .default, handler: { (_) in
            self.navigationController?.pushViewController(BanditCameraViewController(with: self.model), animated: false)
        }))
        
        present(alert, animated: false, completion: nil)
    }
    
    @objc func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Double tap ile like fonksiyonu
    func setUpDoubleTapToLike() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        //            Gesture recognizer için kullanılan selector fonksiyonu
        model.likedByCurrentUser = true
        let touchPoint = gesture.location(in: view) // Gesture'ın nerede yapıldığını CGRECT olarak alıyoruz.
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        
        imageView.tintColor = .systemRed
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = CGPoint(x: view.width/2, y: view.height/2)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        view.addSubview(imageView) // Heart view'a ekleniyor
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                imageView.alpha = 1
            } completion: { (done) in
                if done {
                    UIView.animate(withDuration: 0.3) {
                        imageView.alpha = 0
                        
                    }
                    
                }
            }
        }
        
    }
}

