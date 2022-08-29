//
//  BookmarkViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/26.
//

import UIKit

class BookmarkViewController: BaseViewController {
    
    var listData: BookmarkListResponse? = nil

    @IBOutlet weak var bookmarkTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationTitle(title: "즐겨찾기")
        setBackButton()
        
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
        bookmarkTableView.register(UINib(nibName: "RestaurantSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "RestaurantSearchTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showIndicator()
        BookmarkListDataManager().getBookmarkList(viewController: self)
    }

}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSearchTableViewCell", for: indexPath) as! RestaurantSearchTableViewCell
        cell.name.text = listData?.data?[indexPath.row].name
        cell.category.text = listData?.data?[indexPath.row].category
        cell.roadAddr.text = listData?.data?[indexPath.row].roadAddr
        cell.lnmAddr.text = listData?.data?[indexPath.row].lnmAddr
        cell.telNo.text = listData?.data?[indexPath.row].telNo
        cell.bookmarkButton.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
        if editingStyle == .delete {
            //let index = BookmarkInput(bistroId: listData?.data?[indexPath.row].)
            //BookmarkListDeleteDataManager().deleteBookmark(<#T##parameters: BookmarkInput##BookmarkInput#>, viewController: <#T##BookmarkViewController#>)
            
            listData?.data?.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension BookmarkViewController {
    func getList(response: BookmarkListResponse) {
        dismissIndicator()
        print(response)
        listData = response
        bookmarkTableView.reloadData()
    }
    
    func bookmarkDelete() {
        dismissIndicator()
    }
}
