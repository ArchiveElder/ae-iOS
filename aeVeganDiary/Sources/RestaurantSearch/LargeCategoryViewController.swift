//
//  LargeCategoryViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/10.
//

import UIKit
import RxCocoa
import RxSwift


class LargeCategoryViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var regionBackButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var chooseLable: UILabel!
    
    var regionResponse: RegionResponse?
    var regionArray = [""]
    var tableState : Int = 1
    
    @IBAction func reselctButton(_ sender: Any) {
        tableState = 1
        tableView.reloadData()
    }
    
    let largeCity = ["서울특별시", "경기도", "인천광역시", "강원도", "경상남도", "경상북도", "광주광역시","대구광역시", "대전광역시", "부산광역시", "세종특별자치시","울산광역시", "전라남도", "전라북도", "제주특별자치도", "충청남도", "충청북도"]
    override func viewDidLoad() {
        super.viewDidLoad()
        regionBackButton.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LargeCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "LargeCategoryTableViewCell")
    }
    
}

extension LargeCategoryViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var tableCount = largeCity.count
        if tableState == 1 {
            tableCount = largeCity.count
        } else {
            tableCount = regionArray.count
        }
        return tableCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableState == 1 {
            chooseLable.text = "지역을 선택하세요"
            let cell = tableView.dequeueReusableCell(withIdentifier: "LargeCategoryTableViewCell", for: indexPath)
            cell.textLabel?.text = largeCity[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LargeCategoryTableViewCell", for: indexPath)
            cell.textLabel?.text = regionArray[indexPath.row]
            return cell
        }
    }
    
    //행 선택시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LargeCategoryViewController()
        let largeRegionCell = tableView.cellForRow(at: indexPath)?.textLabel!.text ?? ""
        let inputRegion = RegionInput(wide: largeRegionCell)
        RegionCategoryDataManager().postRegionCategory(RegionInput(wide: largeRegionCell), viewController: self)
        
    }
    
    func getMiddleRegion(result: RegionResponse){
        dismissIndicator()
        self.regionResponse = result
        regionArray = result.data ?? [""]
        print(regionArray)
        tableState = 2
        chooseLable.text = "시를 선택하세요"
        regionBackButton.isHidden = false
        tableView.reloadData()
    }
    
}
