//
//  ViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 8.06.2021.
//

import UIKit
import AMTabView

class HomeViewController: UIViewController {
    
    //    MARK: - 1) ScrollView'ın en temelde oluşturulması
    
    let scrollView: UIScrollView = {  //        Scroll view hem sağa doğru hem sola doğru hareket edebilen bir view
        
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.backgroundColor = .clear
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false //    Scroll View oluşturuluyor, horizontal false ayarlanıyor ki sırf vertical kayabilsin
        scrollView.refreshControl = UIRefreshControl()
        return scrollView
    }()
    
    
    let control: UISegmentedControl = {
        let title = ["Following", "For You"]
        let control = UISegmentedControl(items: title)
        control.selectedSegmentIndex = 1
        return control
    }()
    
    let backgroundBandITImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "logo")
        
        return image
    }()
    
    var postModel = [PostModel]()
    
    let mainPageViewController = UIPageViewController(transitionStyle: .scroll,
                                                        navigationOrientation: .vertical,
                                                        options: [:])
    
    //    MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
        view.addSubview(backgroundBandITImage)
        mainPageViewController.view.backgroundColor = .clear
//        view.addSubview(scrollView)
    
        scrollView.contentInsetAdjustmentBehavior = .never
        
        setUpFeed()
        
        scrollView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPulltoRefresh(_:)), for: .valueChanged)
        scrollView.refreshControl = refreshControl

    }
    
    //    Subview'ın eklenmesi
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds

        backgroundBandITImage.frame = CGRect(x: view.width/2 - 50, y: view.top + 30, width: 100, height: 100)
        
    }
    
    @objc func didPulltoRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.setUpForYouFeed()
            sender.endRefreshing()
        }
    }
    
    //    MARK: - 2) Feed ayarlanıyor
    private func setUpFeed(){
        scrollView.contentSize = CGSize(width: view.width, height: view.height - 50) // Scrollview'ın contentlerinin iki sayfa oluşunu ayarlıyoruz
        setUpForYouFeed()
    }
    //    MARK: - 3) Following ve For you Feed ayarlanıyor
    
    func setUpForYouFeed() {
        setPostViewController(with: PostModel(postURL: URL(fileURLWithPath: ""), user: User(userName: "", profilePictureURL: nil, identifier: "", instrument: ""), banditFileNames: nil))
        
        StorageManager.shared.getFollowingUsersInfo {  (postsToShow, _) in
            
            for postsToShow in postsToShow {
                
                StorageManager.shared.getVideosWithFileName(with: postsToShow, users: nil) { [weak self] (result) in
                    switch result {
                    case .success(let modelWithURL):
                        self?.postModel.insert(modelWithURL, at: 0)
                        self?.setPostViewController(with: modelWithURL)
                    case .none:
                        break
                    case .some(.failure(_)):
                        print("home vc downloadURL error")
                        break
                    }
                }
            }
            
        }
    }
}

//MARK: - Extensions

extension HomeViewController: TabItem {
    var tabImage: UIImage? {
    return UIImage(systemName: "house.fill")
    }
}

//MARK: - SettingPostVC
extension HomeViewController {
    private func setPostViewController(with model: PostModel) {
        
        let vc = PostViewController(model: model)
        
        vc.delegate = self

        mainPageViewController.setViewControllers([vc],
                                                    direction: .forward,
                                                    animated: false,
                                                    completion: nil) // Following pageview VC ekleniyor.
        
        
        mainPageViewController.dataSource = self
        
        view.addSubview(mainPageViewController.view)
//        scrollView.addSubview(mainPageViewController.view)
        
        
        mainPageViewController.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        
        addChild(mainPageViewController)
        mainPageViewController.didMove(toParent: self)
        
    }
}

//MARK: - ViewController Before & After

extension HomeViewController : UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? { // Şuanda bulunduğum VC'den önceki VC'yi getiriyor
        
        guard let fromPost = (viewController as? PostViewController)?.model else {   // User'ın bulunduğu postu buluyoruz.
            return nil
        }
           
        guard let index = currentPosts.firstIndex(where: {  //User'ın bulunduğu post'un index'i
            $0.postURL == fromPost.postURL
            
        }) else {
            return nil
        }
        
        print("Before index is \(index)")
        
        if index == 0 {
            return nil
        }
        
        else {
            //        Bulunduğumuz posttan önceki postun(Yani VC'nin) indexini buluyoruz.
            let priorIndex = index - 1
            let model = currentPosts[priorIndex] // Bir önceki post'un modelinin oluşturulması
            let vc = PostViewController(model: model)
            vc.delegate = self
            return vc
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let fromPost = (viewController as? PostViewController)?.model else {
            print("error from post")
            return nil
        }
        
        guard let index = currentPosts.firstIndex(where: {
            $0.postURL == fromPost.postURL
        })else {
            print("error index")
            return nil
        }
        
        print("After index is \(index)")
        
        guard index < (currentPosts.count - 1) else {
            return nil
        }
        
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        vc.delegate = self
        return vc
        
    }

    //  MARK:-  Şuanda bulunduğum VC'den sonraki VC'yi getiriyor (yukarıydakiyle mantık neredeyse aynı)
    
    //Hangi Sayfada olduğumuzu kontrol ediyoruz.
    
    var currentPosts: [PostModel] {
        return postModel
    }
}
//MARK: - Sayfayı Vertical olarak sağa & sola kaydırdığımız zaman Segmented buttonların değişmesi
extension HomeViewController: UIScrollViewDelegate {

    //    MARK:- Profile Button tıklanması
    
    func postViewController(_vc: PostViewController, didTapProfileButtonFor post: PostModel) {
        let user = post.user
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Postlardaki Comment bölümünün ortaya çıktığı zaman scroll view'ın vertical ya da horizontal kaydırılamaması

extension HomeViewController: PostViewControllerDelegate {

    func postViewController(_vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        let vc = CommentsViewController(post: post)
        vc.delegate = self
        scrollView.isScrollEnabled = false
        if scrollView.contentOffset.x == 0 {
            // Following Page
// böylelikle pageviewcontroller'ın hareket etmemesini sağlıyoruz.
        }
        else {
            mainPageViewController.dataSource = nil
        }
        addChild(vc) // !!!!!! Burada present etmek yerine addchil ediyoruz, Çünkü present ettiğimiz zamanda ana VC Comment vc oluyor ve bu yüzden Post VC ile interaksiyon yapılamıyor.(AlertVC gibi oluyor) Bunun adına MODAL deniyor.
        //Child olarak eklenince hala ana VC post VC oluyor.
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        
        let frame: CGRect = CGRect(x: 0, y: view.height, width: view.width, height: view.height * 0.75)
        vc.view.frame = frame
        UIView.animate(withDuration: 0.2) {
            vc.view.frame = CGRect(x: 0, y: self.view.height - frame.height, width: self.view.width, height: self.view.height * 0.75)
        }
    }
    
    func postViewController(_vc: PostViewController, didTapBanditButtonFor: PostModel) {
        
    }
    
}

extension HomeViewController: CommentViewControllerDelegate {
    func didTapCloseForComments(with viewController: CommentsViewController) {
        //Comment VC kapanacak
        // Protocol yani Delegate yarattık çünkü CommentsVC'deki tuşa tıklama fonksiyonu çalışırken, ana ekrandaki horizontal VC datasource ve delegate'i iptal etmemiz gerekiyordu.
        var frame = viewController.view.frame
        
        UIView.animate(withDuration: 0.2) {
            
            frame = CGRect(x: 0, y: self.view.height, width: self.view.width, height: self.view.height * 0.75)
            
        } completion: { (done) in
            if done {
                DispatchQueue.main.async {
                    //Remove comment vc as child
                    
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                    
                    //allow horizontal and vertical scroll to pageviewcontroller
                    
                    self.scrollView.isScrollEnabled = true
                    self.mainPageViewController.dataSource = self
                    
                    
                }
            }
        }
        
    }
}



