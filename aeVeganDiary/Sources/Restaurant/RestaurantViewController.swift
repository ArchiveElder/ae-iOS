//
//  RestaurantViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/10.
//

import UIKit
import EventKit

struct RegionList {
    var wide: String
    var middle: [String]
}

class RestaurantViewController: UIViewController {
    
    lazy var mapDataManager: MapDataManagerDelegate = MapDataManager()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var siteWideTextField: UITextField!
    @IBOutlet weak var siteMiddleTextField: UITextField!
    
    var regionWidePickerView = UIPickerView()
    var regionMiddlePickerView = UIPickerView()
    var selectedWide: Int = 0
    var selectedMiddle: Int = -1
    
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
    
    let siteList = [RegionList(wide: "전체", middle: ["전체"]),
                    RegionList(wide: "서울특별시", middle: ["전체", "종로구", "동대문구", "영등포구", "종로구", "강남구", "마포구", "양천구", "서초구", "서대문구", "용산구", "구로구", "관악구", "광진구", "은평구", "성북구", "성동구"]),
                RegionList(wide: "경기도", middle: ["전체", "용인시", "고양시", "수원시", "성남시", "화성시", "시흥시"]),
                RegionList(wide: "인천광역시", middle: ["전체", "남동구", "미추홀구"]),
                RegionList(wide: "경상남도", middle: ["전체", "합천군", "창원시", "거제시", "장흥군", "거창군", "함안군"]),
                RegionList(wide: "경상북도", middle: ["전체", "경주시"]),
                RegionList(wide: "광주광역시", middle: ["전체", "동구"]),
                RegionList(wide: "대구광역시", middle: ["전체", "수성구"]),
                RegionList(wide: "대전광역시", middle: ["전체", "유성구", "동구"]),
                RegionList(wide: "부산광역시", middle: ["전체", "수영구", "해운대구"]),
                RegionList(wide: "울산광역시", middle: ["전체", "중구"]),
                RegionList(wide: "전라남도", middle: ["전체", "담양군", "목포시"]),
                RegionList(wide: "전라북도", middle: ["전체", "완주군"]),
                RegionList(wide: "제주특별자치도", middle: ["전체", "서귀포시", "제주시"]),
                RegionList(wide: "충청북도", middle: ["전체", "충주시"])]
    
    var toolBarWide = UIToolbar()
    var toolBarMiddle = UIToolbar()
    
    var location: CLLocation?
    let mapVC = MapViewController()
    let listVC = RestaurantListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapVC.location = self.location
        setUp()
        categoryList = categoryBistro
        
        regionWidePickerView.delegate = self
        regionWidePickerView.dataSource = self
        regionMiddlePickerView.delegate = self
        regionMiddlePickerView.dataSource = self
        
        siteWideTextField.inputView = regionWidePickerView
        siteMiddleTextField.inputView = regionMiddlePickerView
        
        toolBarWide.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(changeRegionWide))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBarWide.setItems([flexSpace, button], animated: true)
        toolBarWide.isUserInteractionEnabled = true
        
        toolBarMiddle.sizeToFit()
        let middleButton = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(changeRegionMiddle))
        toolBarMiddle.setItems([flexSpace, middleButton], animated: true)
        toolBarMiddle.isUserInteractionEnabled = true
        
        siteWideTextField.inputAccessoryView = toolBarWide
        siteMiddleTextField.inputAccessoryView = toolBarMiddle
        
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
    
    @objc func changeRegionWide() {
        dismissKeyboard()
        selectedMiddle = 0
        let wideStr = siteList[selectedWide].wide
        siteWideTextField.text = wideStr
        siteMiddleTextField.text = siteList[selectedWide].middle[selectedMiddle]
        listVC.loadRegionWide(region: wideStr)
    }
    
    @objc func changeRegionMiddle() {
        dismissKeyboard()
        let middleStr = siteList[selectedWide].middle[selectedMiddle]
        siteMiddleTextField.text = middleStr
        listVC.loadRegionMiddle(region: middleStr)
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
        
        if categoryList == categoryBistro {
            if categoryBistroSelectedIndex == indexPath.row {
                categoryBistroSelectedIndex = -1
                if mapVC.view.isHidden {
                    listVC.loadList(mainCategory: "전체", middleCategory: "전체")
                } else {
                    mapVC.loadMap(mainCategory: "전체", middleCategory: "전체")
                }
            } else {
                categoryBistroSelectedIndex = indexPath.row
                categoryCafeSelectedIndex = -1
                if mapVC.view.isHidden {
                    listVC.loadList(mainCategory: "음식점", middleCategory: categoryBistro[categoryBistroSelectedIndex])
                } else {
                    mapVC.loadMap(mainCategory: "음식점", middleCategory: categoryBistro[categoryBistroSelectedIndex])
                }
            }
        } else {
            if categoryCafeSelectedIndex == indexPath.row {
                categoryCafeSelectedIndex = -1
                if mapVC.view.isHidden {
                    listVC.loadList(mainCategory: "전체", middleCategory: "전체")
                } else {
                    mapVC.loadMap(mainCategory: "전체", middleCategory: "전체")
                }
            } else {
                categoryCafeSelectedIndex = indexPath.row
                categoryBistroSelectedIndex = -1
                if mapVC.view.isHidden {
                    listVC.loadList(mainCategory: "카페", middleCategory: categoryCafe[categoryCafeSelectedIndex])
                } else {
                    mapVC.loadMap(mainCategory: "카페", middleCategory: categoryCafe[categoryCafeSelectedIndex])
                }
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

extension RestaurantViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == regionWidePickerView {
            return siteList.count
        } else {
            return siteList[selectedWide].middle.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == regionWidePickerView {
            return siteList[row].wide
        } else {
            return siteList[selectedWide].middle[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //self.categoryIndex = row
        //self.viewModel.category = categories[row]
        //refreshControlTriggered()
        
        if pickerView == regionWidePickerView {
            selectedWide = row
        } else {
            selectedMiddle = row
        }
    }
}
