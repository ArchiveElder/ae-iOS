//
//  RestaurantViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/10.
//

import UIKit
import EventKit

class RestaurantViewController: UIViewController {
    
    lazy var mapDataManager: MapDataManagerDelegate = MapDataManager()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        mapVC.view.isHidden = true
        listVC.view.isHidden = true
        if sender.selectedSegmentIndex == 0 {
            mapVC.view.isHidden = false
            regionView.isHidden = true
            categoryViewTopConstraint.constant = 60
        } else {
            listVC.view.isHidden = false
            regionView.isHidden = false
            categoryViewTopConstraint.constant = 112
        }
    }
    
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBAction func categorySegmentedControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            categoryList = categoryBistro
        } else {
            categoryList = categoryCafe
        }
        categoryCollectionView.reloadData()
    }
    
    var categoryBistroSelectedIndex = -1
    var categoryCafeSelectedIndex = -1
    
    let categoryBistro = ["한식", "사찰음식", "뷔페", "양식", "퓨전음식", "인도음식", "샐러드", "중식"]
    let categoryCafe = ["디저트", "베이커리", "과일/주스", "브런치"]
    var categoryList: [String] = []
    
    var location: CLLocation?
    let mapVC = MapViewController()
    let listVC = RestaurantListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapVC.location = self.location
        setUp()
        categoryList = categoryBistro
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        categoryCollectionView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            regionView.isHidden = false
            categoryViewTopConstraint.constant = 112
        } else {
            mapVC.view.isHidden = false
            listVC.view.isHidden = true
            segmentedControl.selectedSegmentIndex = 0
            regionView.isHidden = true
            categoryViewTopConstraint.constant = 60
        }
        
    }

}

extension RestaurantViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.categoryLabel.text = categoryList[indexPath.row]
        if categoryList == categoryBistro {
            if categoryBistroSelectedIndex == indexPath.row {
                cell.categoryBackgroundView.borderColor = .darkGreen
                cell.categoryBackgroundView.backgroundColor = .mainGreen
            } else {
                cell.categoryBackgroundView.borderColor = .mainGreen
                cell.categoryBackgroundView.backgroundColor = .white
            }
        } else {
            if categoryCafeSelectedIndex == indexPath.row {
                cell.categoryBackgroundView.borderColor = .darkGreen
                cell.categoryBackgroundView.backgroundColor = .mainGreen
            } else {
                cell.categoryBackgroundView.borderColor = .mainGreen
                cell.categoryBackgroundView.backgroundColor = .white
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        categoryBistroSelectedIndex = -1
        categoryCafeSelectedIndex = -1
        if categoryList == categoryBistro {
            categoryBistroSelectedIndex = indexPath.row
            if mapVC.view.isHidden {
                listVC.loadList(mainCategory: "음식점", middleCategory: categoryBistro[categoryBistroSelectedIndex])
            } else {
                mapVC.loadMap(mainCategory: "음식점", middleCategory: categoryBistro[categoryBistroSelectedIndex])
            }
            
        } else {
            categoryCafeSelectedIndex = indexPath.row
            if mapVC.view.isHidden {
                listVC.loadList(mainCategory: "카페", middleCategory: categoryCafe[categoryCafeSelectedIndex])
            } else {
                mapVC.loadMap(mainCategory: "카페", middleCategory: categoryCafe[categoryCafeSelectedIndex])
            }
        }
        categoryCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.text = categoryList[indexPath.row]
        label.sizeToFit()
        let size = label.frame.size
        
        return CGSize(width: size.width + 30, height: 36)
    }
}
