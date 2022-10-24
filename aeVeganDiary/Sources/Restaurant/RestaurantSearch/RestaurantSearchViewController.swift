//
//  RestaurantSearchViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/12.
//

import UIKit
import RxCocoa
import RxSwift

class RestaurantSearchViewController: UIViewController {

    lazy var bookmarkDataManager: BookmarkDataManagerDelegate = BookmarkDataManager()
    lazy var bookmarkDeleteDataManager: BookmarkDeleteDataManagerDelegate = BookmarkDeleteDataManager()
    
    @IBOutlet var middleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    var rowCount : Int = 0
    var middle : String = ""
    var bookmarked : Int = 2
    var data : [CategoryListDto] = []
    var bistroIdArr: [CLong] = []
    var isBookmarkArr : [Int] = []
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
            categoryArr.append(data[i].category ?? "")
            roadAddrArr.append(data[i].roadAddr ?? "")
            lnmAddrArr.append(data[i].lnmAddr ?? "")
            telNoArr.append(data[i].telNo ?? "")
            isBookmarkArr.append(data[i].isBookmark)
            bistroIdArr.append(data[i].bistroId)
        }
    }

}

extension RestaurantSearchViewController : UITableViewDataSource, UITableViewDelegate, RestaurantSearchTableViewCellDelegate {
    func bookmarkButtonAction(cell: RestaurantSearchTableViewCell) {
        var indexPath = tableView.indexPath(for: cell)?[1]
        let inputBistroId = BookmarkRequest(bistroId: bistroIdArr[indexPath!])
        
        //안눌렸으면
        if(cell.searchBookmarkButton.isSelected == false){
            bookmarkDataManager.postBookmark(inputBistroId, delegate: self)
            cell.searchBookmarkButton.isSelected = true
        }
        //눌렸으면
        else if(cell.searchBookmarkButton.isSelected == true){
            bookmarkDeleteDataManager.deleteBookmark(inputBistroId, delegate: self)
            cell.searchBookmarkButton.isSelected = false
        }
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vc = RestaurantSearchViewController()
        let cell : RestaurantSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSearchTableViewCell", for: indexPath) as! RestaurantSearchTableViewCell
        
        cell.nameLabel?.text = nameArr[indexPath.row]
        cell.categoryLabel?.text = categoryArr[indexPath.row]
        cell.roadAddrLabel?.text = roadAddrArr[indexPath.row]
        cell.lnmAddrLabel?.text = lnmAddrArr[indexPath.row]
        cell.telNoLabel?.text = telNoArr[indexPath.row]
        //즐겨찾기 조회
        if(isBookmarkArr[indexPath.row] == 1) {
            cell.searchBookmarkButton.isSelected=true
        } else {
            cell.searchBookmarkButton.isSelected=false
        }
        cell.delegate = self
        return cell
    }
}

extension RestaurantSearchViewController: BookmarkViewDelegate, BookmarkDeleteViewDelegate {
    func didSuccessPostBookmark(_ result: BookmarkResponse) {
        dismissIndicator()
    }
    
    func didSuccessDeleteBookmark(_ result: BookmarkResponse) {
        dismissIndicator()
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
}