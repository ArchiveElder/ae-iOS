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
    @IBOutlet weak var dimmedView: UIView!
    
    var restaurantList = [MapData]()
    var filteredRestaurantList = [MapData]()
    
    var mainCategory = ""
    var middleCategory = ""
    
    var siteWide = ""
    var siteMiddle = ""
    
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
        
        if siteWide == "" {
            if middleCategory == "전체" {
                filteredRestaurantList = restaurantList
                self.mainCategory = ""
                self.middleCategory = ""
            } else {
                filteredRestaurantList = restaurantList.filter { $0.mainCategory == mainCategory && $0.middleCategory == middleCategory }
            }
        } else {
            if siteMiddle == "" {
                if middleCategory == "전체" {
                    filteredRestaurantList = restaurantList.filter { $0.siteWide == siteWide }
                    self.mainCategory = ""
                    self.middleCategory = ""
                } else {
                    filteredRestaurantList = restaurantList.filter { $0.mainCategory == mainCategory && $0.middleCategory == middleCategory && $0.siteWide == siteWide }
                }
            } else {
                if middleCategory == "전체" {
                    filteredRestaurantList = restaurantList.filter { $0.siteWide == siteWide && $0.siteMiddle == siteMiddle }
                    self.mainCategory = ""
                    self.middleCategory = ""
                } else {
                    filteredRestaurantList = restaurantList.filter { $0.mainCategory == mainCategory && $0.middleCategory == middleCategory && $0.siteWide == siteWide && $0.siteMiddle == siteMiddle }
                }
                
            }
        }
        
        hideDimmedView()
        
        self.restaurantTableView.reloadData()
    }
    
    func loadRegionWide(region: String) {
        self.siteWide = region
        self.siteMiddle = ""
        
        if self.mainCategory == "" || self.middleCategory == ""  {
            if region == "전체" {
                self.siteWide = ""
                filteredRestaurantList = restaurantList
            } else {
                filteredRestaurantList = restaurantList.filter{ $0.siteWide == siteWide }
            }
        } else {
            if region == "전체" {
                self.siteWide = ""
                filteredRestaurantList = restaurantList.filter{ $0.mainCategory == mainCategory && $0.middleCategory == middleCategory }
            } else {
                filteredRestaurantList = restaurantList.filter{ $0.mainCategory == mainCategory && $0.middleCategory == middleCategory && $0.siteWide == siteWide }
            }
        }
        
        
        
        hideDimmedView()
        
        self.restaurantTableView.reloadData()
    }
    
    func loadRegionMiddle(region: String) {
        self.siteMiddle = region
        
        if self.mainCategory == "" || self.middleCategory == "" {
            if region == "전체" {
                self.siteMiddle = ""
                filteredRestaurantList = restaurantList.filter{ $0.siteWide == siteWide }
            } else {
                filteredRestaurantList = restaurantList.filter{ $0.siteWide == siteWide && $0.siteMiddle == siteMiddle }
            }
        } else {
            if region == "전체" {
                self.siteMiddle = ""
                filteredRestaurantList = restaurantList.filter{ $0.mainCategory == mainCategory && $0.middleCategory == middleCategory && $0.siteWide == siteWide }
            } else {
                filteredRestaurantList = restaurantList.filter{ $0.mainCategory == mainCategory && $0.middleCategory == middleCategory && $0.siteWide == siteWide && $0.siteMiddle == siteMiddle }
            }
        }
        
        hideDimmedView()
        
        self.restaurantTableView.reloadData()
    }
    
    func hideDimmedView() {
        if filteredRestaurantList.isEmpty {
            dimmedView.isHidden = false
        } else {
            dimmedView.isHidden = true
        }
    }
}

extension RestaurantListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredRestaurantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantListTableViewCell", for: indexPath) as! RestaurantListTableViewCell
        cell.selectionStyle = .none
        var resData: MapData? = nil
        resData = filteredRestaurantList[indexPath.row]
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
        resData = filteredRestaurantList[sender.tag]
        if sender.isSelected {
            showIndicator()
            let input = BookmarkRequest(bistroId: resData?.bistro_id ?? 0)
            print(input)
            bookmarkDeleteDataManager.deleteBookmark(input, delegate: self)
        } else {
            showIndicator()
            let input = BookmarkRequest(bistroId: resData?.bistro_id ?? 0)
            print(input)
            bookmarkDataManager.postBookmark(input, delegate: self)
        }
    }
    
    @objc func toDetail(sender: UIButton) {
        var resData: MapData? = nil
        resData = filteredRestaurantList[sender.tag]
        
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
        self.filteredRestaurantList = restaurantList
        loadList(mainCategory: self.mainCategory, middleCategory: self.middleCategory)
        
        hideDimmedView()
        
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

