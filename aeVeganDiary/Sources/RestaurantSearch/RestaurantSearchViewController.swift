//
//  RestaurantSearchViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/12.
//

import UIKit
import RxCocoa
import RxSwift

class RestaurantSearchViewController: UIViewController, UITableViewDelegate {

    
    @IBOutlet var middleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    var rowCount : Int = 0
    var middle : String = ""
    var data : [CategoryListDto] = []
    var nameArr : [String] = []
    var categoryArr : [String] = []
    var roadAddrArr : [String] = []
    var lnmAddrArr : [String] = []
    var telNoArr : [String] = []
    
    @IBOutlet var restaurantTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantTableView.dataSource = self
        restaurantTableView.delegate = self
        restaurantTableView.register(UINib(nibName: "RestaurantSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "RestaurantSearchTableViewCell")
        restaurantTableView.estimatedRowHeight = 200
        middleLabel.text = middle
        
        for i in 0...rowCount-1  {
            nameArr.append(data[i].name)
            categoryArr.append(data[i].category)
            roadAddrArr.append(data[i].roadAddr)
            lnmAddrArr.append(data[i].lnmAddr)
            telNoArr.append(data[i].telNo)
        }
    }

}

extension RestaurantSearchViewController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vc = RestaurantSearchViewController()
        let cell : RestaurantSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSearchTableViewCell", for: indexPath) as! RestaurantSearchTableViewCell
        
        cell.name?.text = nameArr[indexPath.row]
        cell.category?.text = categoryArr[indexPath.row]
        cell.roadAddr?.text = roadAddrArr[indexPath.row]
        cell.lnmAddr?.text = lnmAddrArr[indexPath.row]
        cell.telNo?.text = telNoArr[indexPath.row]
        
        return cell
    }
    
    
}