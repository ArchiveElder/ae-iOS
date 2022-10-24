//
//  BookmarkViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/08/26.
//

import UIKit
import SafariServices

class BookmarkViewController: BaseViewController {
    
    lazy var bookmarkListDataManager: BookmarkListDataManagerDelegate = BookmarkListDataManager()
    lazy var bookmarkDeleteDataManager: BookmarkDeleteDataManagerDelegate = BookmarkDeleteDataManager()
    
    var listData: BookmarkListResult? = nil

    @IBOutlet weak var bookmarkTableView: UITableView!
    
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
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
        self.view.backgroundColor = .white
        showIndicator()
        bookmarkListDataManager.getBookmarkList(delegate: self)
    }

}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSearchTableViewCell", for: indexPath) as! RestaurantSearchTableViewCell
        cell.nameLabel.text = listData?.data?[indexPath.row].name
        cell.categoryLabel.text = listData?.data?[indexPath.row].category
        cell.roadAddrLabel.text = listData?.data?[indexPath.row].roadAddr
        cell.lnmAddrLabel.text = listData?.data?[indexPath.row].lnmAddr
        cell.telNoLabel.text = listData?.data?[indexPath.row].telNo
        cell.searchBookmarkButton.isSelected = true
        cell.searchBookmarkButton.tag = indexPath.row
        cell.searchBookmarkButton.addTarget(self, action: #selector(bookmarkDelete(sender: )), for: .touchUpInside)
        
        cell.restaurantDetailButton.tag = indexPath.row
        cell.restaurantDetailButton.addTarget(self, action: #selector(restaurantWebView(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func restaurantWebView(sender: UIButton) {
        let url = URL(string: listData?.data?[sender.tag].bistroUrl ?? "")!
        let safariView : SFSafariViewController = SFSafariViewController(url: url)
        present(safariView, animated: true, completion: nil)
    }
    
    @objc func bookmarkDelete(sender: UIButton) {
        let input = BookmarkRequest(bistroId: listData?.data?[sender.tag].bistroId ?? 0)
        bookmarkDeleteDataManager.deleteBookmark(input, delegate: self)
    }
}

extension BookmarkViewController: BookmarkListViewDelegate, BookmarkDeleteViewDelegate {
    func didSuccessGetBookmarkList(_ result: BookmarkListResponse) {
        dismissIndicator()
        listData = result.result
        if listData?.data?.count == 0 {
            messageLabel.isHidden = false
            messageImageView.isHidden = false
            bookmarkTableView.isHidden = true
        } else {
            messageLabel.isHidden = true
            messageImageView.isHidden = true
            bookmarkTableView.isHidden = false
        }
        bookmarkTableView.reloadData()
    }
    
    func didSuccessDeleteBookmark(_ result: BookmarkResponse) {
        dismissIndicator()
        showIndicator()
        bookmarkListDataManager.getBookmarkList(delegate: self)
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
