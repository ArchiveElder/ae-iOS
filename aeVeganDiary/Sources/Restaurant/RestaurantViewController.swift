//
//  RestaurantViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/10.
//

import UIKit
import EventKit

class RestaurantViewController: UIViewController {
    
    var location: CLLocation?
    let mapVC = MapViewController()
    let largeCategoryVC = LargeCategoryViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapVC.location = self.location
        setToggleButton()
        setUp()
    }
    
    let toggleButton: UIButton = UIButton()
    
    func setToggleButton() {
        toggleButton.setImage(UIImage(named: "map"), for: .normal)
        toggleButton.setImage(UIImage(named: "apps"), for: .selected)
        toggleButton.addTarget(self, action: #selector(toggle(sender: )), for: .touchUpInside)
        toggleButton.frame = CGRect(x: 18, y: 0, width: 44, height: 44)
        let addToggleButton = UIBarButtonItem(customView: toggleButton)
        
        self.navigationItem.setRightBarButton(addToggleButton, animated: false)
    }
    
    @objc func toggle(sender: UIButton) {
        mapVC.view.isHidden = true
        largeCategoryVC.view.isHidden = true
        if sender.isSelected {
            sender.isSelected = false
            mapVC.view.isHidden = false
        } else {
            sender.isSelected = true
            largeCategoryVC.view.isHidden = false
        }
    }
    
    func setUp() {
        addChild(mapVC)
        addChild(largeCategoryVC)
        
        self.view.addSubview(mapVC.view)
        self.view.addSubview(largeCategoryVC.view)
        
        mapVC.didMove(toParent: self)
        largeCategoryVC.didMove(toParent: self)
        
        mapVC.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        largeCategoryVC.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        if location == nil {
            mapVC.view.isHidden = true
            largeCategoryVC.view.isHidden = false
            toggleButton.isSelected = true
        } else {
            mapVC.view.isHidden = false
            largeCategoryVC.view.isHidden = true
            toggleButton.isSelected = false
        }
        
    }

}
