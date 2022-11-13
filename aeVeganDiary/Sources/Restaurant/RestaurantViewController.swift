//
//  RestaurantViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/10.
//

import UIKit
import EventKit

class RestaurantViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        mapVC.view.isHidden = true
        listVC.view.isHidden = true
        if sender.selectedSegmentIndex == 0 {
            mapVC.view.isHidden = false
        } else {
            listVC.view.isHidden = false
        }
    }
    
    var location: CLLocation?
    let mapVC = MapViewController()
    let listVC = RestaurantListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapVC.location = self.location
        setUp()
    }
    
    func setUp() {
        addChild(mapVC)
        addChild(listVC)
        
        self.view.addSubview(mapVC.view)
        self.view.addSubview(listVC.view)
        
        self.view.bringSubviewToFront(regionView)
        self.view.bringSubviewToFront(categoryView)
        self.view.bringSubviewToFront(segmentedControl)
        self.view.bringSubviewToFront(dismissButton)
        
        mapVC.didMove(toParent: self)
        listVC.didMove(toParent: self)
        
        mapVC.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        listVC.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        if location == nil {
            mapVC.view.isHidden = true
            listVC.view.isHidden = false
            segmentedControl.selectedSegmentIndex = 1
        } else {
            mapVC.view.isHidden = false
            listVC.view.isHidden = true
            segmentedControl.selectedSegmentIndex = 0
        }
        
    }

}
