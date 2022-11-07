//
//  BaseTabBarController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/28.
//

import UIKit
import SwiftUI

class BaseTabBarController: UITabBarController, UITabBarControllerDelegate  {

    let homeViewController = HomeViewController()
    let homeTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "home"), tag: 0)
    
    let analyzeViewController = AnalyzeViewController()
    let analyzeTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "analyze"), tag: 1)
    
    //let cookRecommViewController = UIHostingController(rootView: SearchView())\
    let cookRecommViewController = RecommCookViewController()
    let cookRecommTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "cookRecomm"), tag:2)
    
    let boardViewController = BoardViewController()
    let boardTabBarItem = UITabBarItem(title: nil, image: UIImage(named: "board"), tag: 3)

    
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
        let cookRecommNavController = UINavigationController(rootViewController: cookRecommViewController)
        let boardNavController = UINavigationController(rootViewController: boardViewController)
        
        homeNavController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        homeNavController.navigationController?.navigationBar.shadowImage = UIImage()
        homeNavController.navigationController?.navigationBar.layoutIfNeeded()
        
        analyzeNavController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        analyzeNavController.navigationController?.navigationBar.shadowImage = UIImage()
        analyzeNavController.navigationController?.navigationBar.layoutIfNeeded()
        
        cookRecommNavController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        cookRecommNavController.navigationController?.navigationBar.shadowImage = UIImage()
        cookRecommNavController.navigationController?.navigationBar.layoutIfNeeded()
        
        boardNavController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        boardNavController.navigationController?.navigationBar.shadowImage = UIImage()
        boardNavController.navigationController?.navigationBar.layoutIfNeeded()
        
        homeNavController.tabBarItem = homeTabBarItem
        analyzeNavController.tabBarItem = analyzeTabBarItem
        cookRecommNavController.tabBarItem = cookRecommTabBarItem
        boardNavController.tabBarItem = boardTabBarItem
        
        
        self.viewControllers = [homeNavController, analyzeNavController, cookRecommNavController, boardNavController]
        
        self.delegate = self
    }
    

}
