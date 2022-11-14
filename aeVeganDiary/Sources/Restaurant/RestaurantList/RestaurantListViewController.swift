//
//  RestaurantListViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/13.
//

import UIKit

class RestaurantListViewController: UIViewController {
    
    lazy var mapDataManager: MapDataManagerDelegate = MapDataManager()

    @IBOutlet weak var restaurantTableView: UITableView!
    
    var restaurantList = [MapData]()
    var filteredRestaurantList = [MapData]()
    
    var mainCategory = ""
    var middleCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantTableView.delegate = self
        restaurantTableView.dataSource = self
        restaurantTableView.register(UINib(nibName: "RestaurantSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "RestaurantSearchTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapDataManager.getMap(delegate: self)
    }
    
    func loadList(mainCategory: String, middleCategory: String) {
        if mainCategory == "" || middleCategory == "" {
            return
        }
        
        self.mainCategory = mainCategory
        self.middleCategory = middleCategory
        
        filteredRestaurantList = restaurantList.filter{ $0.mainCategory == mainCategory && $0.middleCategory == middleCategory }
        
        self.restaurantTableView.reloadData()
    }
}

extension RestaurantListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredRestaurantList.isEmpty {
            return restaurantList.count
        } else {
            return filteredRestaurantList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSearchTableViewCell", for: indexPath) as! RestaurantSearchTableViewCell
        var resData: MapData? = nil
        if filteredRestaurantList.isEmpty {
            resData = restaurantList[indexPath.row]
        } else {
            resData = filteredRestaurantList[indexPath.row]
        }
        cell.nameLabel.text = resData?.name
        cell.categoryLabel.text = resData?.middleCategory
        return cell
    }
}

// MARK: 서버 통신
extension RestaurantListViewController: MapViewDelegate, BookmarkViewDelegate, BookmarkDeleteViewDelegate {
    func didSuccessGetMap(_ result: MapResponse) {
        dismissIndicator()
        self.restaurantList = result.result?.data ?? []
        self.restaurantTableView.reloadData()
    }
    
    func failedToRequest(message: String, code: Int) {
        dismissIndicator()
        presentAlert(message: message)
        if code == 403 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.changeRootViewController(LoginViewController())
            }
        }
    }
    
    func didSuccessPostBookmark(_ result: BookmarkResponse) {
        mapDataManager.getMap(delegate: self)
    }
    
    func didSuccessDeleteBookmark(_ result: BookmarkResponse) {
        mapDataManager.getMap(delegate: self)
    }
}

