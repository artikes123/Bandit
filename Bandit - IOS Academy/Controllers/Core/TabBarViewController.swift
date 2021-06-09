//
//  TabBarViewController.swift
//  Bandit - IOS Academy
//
//  Created by Artun Erol on 8.06.2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
        // Do any additional setup after loading the view.
    }


    private func setUpControllers() {
        
//        Tab bardaki controllerları tab bar item yapmak için kullanacağız
        
        let home = HomeViewController()
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let notifications = NotificationsViewController()
        let profile = ProfileViewController()
        
//        Tab Bar için oluşturulan title'lar aşağıdaki tab barda da title olarak kalıyor ancak simge olarak gelmiyor.
        
        home.title = "Home"
        explore.title = "Explore"
        notifications.title = "Notifications"
        profile.title = "Profile"

        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: notifications)
        let nav4 = UINavigationController(rootViewController: profile)
        
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), tag: 2)
        camera.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "camera"), tag: 3)
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell"), tag: 4)
        nav4.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.crop.circle"), tag: 5)

        
        setViewControllers([nav1, nav2, camera, nav3, nav4], animated: false)
    }

}
