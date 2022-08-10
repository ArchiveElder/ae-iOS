//
//  RestaurantViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/10.
//

import UIKit

class RestaurantViewController: UIViewController {
    
    let mapVC = MapViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func setToggleButton() {
        
    }
    
    func setUp() {
        addChild(mapVC)
        //addChild(storyVC)
        
        self.view.addSubview(mapVC.view)
        //self.view.addSubview(storyVC.view)
        
        mapVC.didMove(toParent: self)
        //storyVC.didMove(toParent: self)
        
        mapVC.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        //storyVC.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        mapVC.view.isHidden = false
        //storyVC.view.isHidden = true
    }

}
