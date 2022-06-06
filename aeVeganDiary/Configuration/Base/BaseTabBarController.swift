//
//  BaseTabBarController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/28.
//

import UIKit

class BaseTabBarController: UITabBarController, UITabBarControllerDelegate  {

    let homeViewController = HomeViewController()
    let homeTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "home"), tag: 0)
    
    let analyzeViewController = AnalyzeViewController()
    let analyzeTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "analyze"), tag: 1)
    
    let albumViewController = AlbumViewController()
    let albumTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "album"), tag: 2)
    
    let mypageViewController = MypageViewController()
    let mypageTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "mypage"), tag: 3)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
        
        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        tabBar.tintColor = .darkGreen
        view.backgroundColor = .white
        
        let homeNavController = UINavigationController(rootViewController: homeViewController)
        let analyzeNavController = UINavigationController(rootViewController: analyzeViewController)
        let albumNavController = UINavigationController(rootViewController: albumViewController)
        let mypageNavController = UINavigationController(rootViewController: mypageViewController)
        
        homeNavController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        homeNavController.navigationController?.navigationBar.shadowImage = UIImage()
        homeNavController.navigationController?.navigationBar.layoutIfNeeded()
        
        analyzeNavController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        analyzeNavController.navigationController?.navigationBar.shadowImage = UIImage()
        analyzeNavController.navigationController?.navigationBar.layoutIfNeeded()
        
        albumNavController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        albumNavController.navigationController?.navigationBar.shadowImage = UIImage()
        albumNavController.navigationController?.navigationBar.layoutIfNeeded()
        
        mypageNavController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        mypageNavController.navigationController?.navigationBar.shadowImage = UIImage()
        mypageNavController.navigationController?.navigationBar.layoutIfNeeded()
        
        homeNavController.tabBarItem = homeTabBarItem
        analyzeNavController.tabBarItem = analyzeTabBarItem
        albumNavController.tabBarItem = albumTabBarItem
        mypageNavController.tabBarItem = mypageTabBarItem
        
        
        self.viewControllers = [homeNavController, analyzeNavController, albumNavController, mypageNavController]
        
        self.delegate = self
    }
    

}
