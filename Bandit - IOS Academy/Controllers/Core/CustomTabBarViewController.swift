//
//  CustomTabBarViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 11.08.2021.
//

import UIKit
import AMTabView

class CustomTabBarViewController: AMTabsViewController {
    
    private var signInPresented = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !signInPresented {
            presentSignInIfNeeded()
        }
    }

    func presentSignInIfNeeded() {
        if !AuthManager.shared.isSignedIn {
            let vc = SignInViewController()
            vc.completion = { [weak self] in
                self?.signInPresented = false
            }
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: false, completion: nil)
            signInPresented = true
        }
      
    }
  
    private func setUpControllers() {

//        Tab bardaki controllerları tab bar item yapmak için kullanacağız
        
        let home = HomeViewController()
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let notifications = NotificationsViewController()
        let categories = MusicCategoriesViewController()
        
        var profilePictureURL: String?
        if let cachedProfilePictureURL = UserDefaults.standard.value(forKey: "profile_picture") as? String {
            profilePictureURL = cachedProfilePictureURL
        }
    
        let profile = CurrentUserProfileViewController(user: User(userName: UserDefaults.standard.string(forKey: "username") ?? "Me",
                                                       profilePictureURL: URL(string: profilePictureURL ?? ""),
                                                       identifier: UserDefaults.standard.string(forKey: "username")?.lowercased() ?? "", instrument: "" ))
        
//Tab Bar için oluşturulan title'lar aşağıdaki tab barda da title olarak kalıyor ancak simge olarak gelmiyor.
        

        notifications.title = "Notifications"
        profile.title = "Profile"

        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: categories)
        let nav3 = UINavigationController(rootViewController: notifications)
        let nav4 = UINavigationController(rootViewController: profile)
        let cameraNav = UINavigationController(rootViewController: camera)
        
        
//        Home navigation bar'ı görünmez yapıyoruz
        nav1.navigationBar.backgroundColor = .clear
        nav1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav1.navigationBar.shadowImage = UIImage()
        
        cameraNav.navigationBar.backgroundColor = .clear
        cameraNav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        cameraNav.navigationBar.shadowImage = UIImage()
        cameraNav.navigationBar.tintColor = .white
        
        nav3.navigationBar.tintColor = .label
        nav4.navigationBar.tintColor = .label
        
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), tag: 2)
        camera.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "camera"), tag: 3)
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell"), tag: 4)
        nav4.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.crop.circle"), tag: 5)
        
        viewControllers = [nav1, nav2, cameraNav, nav3, nav4]
        
        
    }

}
