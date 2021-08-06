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
}

class PostViewController: UIViewController {
    
    weak var delegate: PostViewControllerDelegate?
    
    
    var model: PostModel
    //  MARK: - Buttonların obje olarak oluşturulması
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
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
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "Test"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.masksToBounds = true
        
        return button
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - DidLoad && viewLayOut
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideo(with: model)
        view.addSubview(spinner)
        view.addSubview(videoView)
        view.backgroundColor = .black
        view.frame = CGRect(x: 0, y: 10, width: view.width, height: 200)
        
        setUpButtons()
        setUpDoubleTapToLike()
        view.addSubview(captionLabel)
        view.addSubview(profileButton)
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)

    }
    
    override func viewDidLayoutSubviews() { // Subview'ların konumlarını vs (CGRECT) ayarlıyoruz.
        super.viewDidLayoutSubviews()
        
        videoView.frame = CGRect(x: 5, y: view.safeAreaInsets.top, width: view.width - 10, height: view.height - (tabBarController?.tabBar.frame.height)!)
        videoView.layer.cornerRadius = 10
        
        videoView.backgroundColor = .darkGray
        
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
        
        //MARK: - Buttonların CGRect setup
        let size : CGFloat = 45
        let yStart: CGFloat = view.height - (size * 4) - view.safeAreaInsets.bottom
        for (index, button) in [likeButton,commentButton,shareButton].enumerated() {
            button.frame = CGRect(x: view.width - size - 10, y: yStart + (CGFloat(index) * size),  width: size, height: size)
           
        }
        //Caption Label
        captionLabel.sizeToFit()
        let labelSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 10, height: view.height)) // Comment'in belirlenen alana sığması gerektiğini belirtiyoruz.
        captionLabel.frame = CGRect(x: 5,
                                    y: videoView.bottom - labelSize.height - 5,
                                    width: view.width - size - 12,
                                    height: labelSize.height)
        //ProfileButton
        profileButton.frame = CGRect(x: videoView.left + 10,
                                     y: videoView.top + 5,
                                     width: size,
                                     height: size)
        
        profileButton.layer.cornerRadius = size/2
    }
    
    private func configureVideo(with model: PostModel) {

                // Video path'i URL'ye çevirdik
                player = AVPlayer(url: model.postURL) // Vİdeo'yu player'a atmak
            
                let playerLayer1 = AVPlayerLayer(player: player) //Video'yu ekranda gösterebilmek için onu AVPLayer layer'a dönüştürüyoruz
                playerLayer1.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height/2)
                playerLayer1.videoGravity = .resizeAspect
                
                let playerLayer2 = AVPlayerLayer(player: player) //Video'yu ekranda gösterebilmek için onu AVPLayer layer'a dönüştürüyoruz
                playerLayer2.frame = CGRect(x: 0 , y: view.height/2, width: view.width, height: view.height/2)
                playerLayer2.videoGravity = .resizeAspect
                
                player?.volume = 0
                
                videoView.layer.addSublayer(playerLayer1)
                videoView.layer.addSublayer(playerLayer2)
                
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
  
    //    MARK: - Setting UP  buttons
    
    func setUpButtons() {
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
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
