//
//  RestaurantListViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/13.
//

import UIKit
import SafariServices

class RestaurantListViewController: UIViewController {
    
    lazy var mapDataManager: MapDataManagerDelegate = MapDataManager()
    lazy var bookmarkDataManager: BookmarkDataManagerDelegate = BookmarkDataManager()
    lazy var bookmarkDeleteDataManager: BookmarkDeleteDataManagerDelegate = BookmarkDeleteDataManager()

    @IBOutlet weak var restaurantTableView: UITableView!
    
    var restaurantList = [MapData]()
    var filteredRestaurantList = [MapData]()
    
    var mainCategory = ""
    var middleCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantTableView.delegate = self
        restaurantTableView.dataSource = self
        restaurantTableView.register(UINib(nibName: "RestaurantListTableViewCell", bundle: nil), forCellReuseIdentifier: "RestaurantListTableViewCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantListTableViewCell", for: indexPath) as! RestaurantListTableViewCell
        cell.selectionStyle = .none
        var resData: MapData? = nil
        if filteredRestaurantList.isEmpty {
            resData = restaurantList[indexPath.row]
        } else {
            resData = filteredRestaurantList[indexPath.row]
        }
        cell.nameLabel.text = resData?.name
        cell.categoryLabel.text = resData?.middleCategory
        cell.roadAddrLabel.text = resData?.roadAddr
        cell.lnmAddrLabel.text = resData?.lnmAddr
        
        cell.bookmarkButton.tag = indexPath.row
        cell.bookmarkButton.isSelected = resData?.isBookmark == 1 ? true : false
        cell.bookmarkButton.addTarget(self, action: #selector(bookmark(sender:)), for: .touchUpInside)
        cell.detailButton.tag = indexPath.row
        cell.detailButton.addTarget(self, action: #selector(toDetail(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func bookmark(sender: UIButton) {
        var resData: MapData? = nil
        if filteredRestaurantList.isEmpty {
            resData = restaurantList[sender.tag]
        } else {
            resData = filteredRestaurantList[sender.tag]
        }
        if sender.isSelected {
            showIndicator()
            let input = BookmarkRequest(bistroId: resData?.bistro_id ?? 0)
            bookmarkDeleteDataManager.deleteBookmark(input, delegate: self)
        } else {
            showIndicator()
            let input = BookmarkRequest(bistroId: resData?.bistro_id ?? 0)
            bookmarkDataManager.postBookmark(input, delegate: self)
        }
    }
    
    @objc func toDetail(sender: UIButton) {
        var resData: MapData? = nil
        if filteredRestaurantList.isEmpty {
            resData = restaurantList[sender.tag]
        } else {
            resData = filteredRestaurantList[sender.tag]
        }
        
        let urlStr = resData?.bistroUrl ?? "https://www.naver.com/"
        if let url = URL(string: urlStr) {
            let safariView : SFSafariViewController = SFSafariViewController(url: url)
            present(safariView, animated: true, completion: nil)
        }
    }
}

// MARK: 서버 통신
extension RestaurantListViewController: MapViewDelegate, BookmarkViewDelegate, BookmarkDeleteViewDelegate {
    func didSuccessGetMap(_ result: MapResponse) {
        dismissIndicator()
        self.restaurantList = result.result?.data ?? []
        loadList(mainCategory: self.mainCategory, middleCategory: self.middleCategory)
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

