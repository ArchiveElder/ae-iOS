//
//  PostingDetailViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/09.
//

import UIKit

class PostingDetailViewController: BaseViewController {
    
    @IBOutlet weak var postingDetailTableView: UITableView?
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postCommentButton: UIButton!
    
    var postingDetailResponse : PostingDetailResponse?
    
    lazy var getPostingDetailDataManager: GetPostingDetailDataManager = GetPostingDetailDataManager()
    
    
    var nickname : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackButton()
        setMoreButton()
        
        postingDetailTableView?.delegate = self
        postingDetailTableView?.dataSource = self
        postingDetailTableView?.register(UINib(nibName: "PostingDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "PostingDetailTableViewCell")
        let headerNib = UINib(nibName: "PostingDetailHeaderView", bundle: nil)
        postingDetailTableView?.register(headerNib, forHeaderFooterViewReuseIdentifier: "PostingDetailHeaderView")
        postingDetailTableView?.sectionHeaderHeight = UITableView.automaticDimension
        
        postingDetailTableView?.rowHeight = UITableView.automaticDimension
        
        getPostingDetailDataManager.getPostingDetailData(137, postIdx: 54, delegate: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getPostingDetailDataManager.getPostingDetailData(137, postIdx: 54, delegate: self)
    }

    func setMoreButton() {
        let moreButton: UIButton = UIButton()
        let moreButtonImage = UIImage(systemName: "ellipsis.circle")?.withRenderingMode(.alwaysTemplate)
        moreButton.setImage(moreButtonImage, for: .normal)
        moreButton.tintColor = UIColor.darkGreen
        moreButton.addTarget(self, action: #selector(showDetailBottomSheet), for: .touchUpInside)
        moreButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let addMoreButton = UIBarButtonItem(customView: moreButton)
        
        self.navigationItem.setRightBarButton(addMoreButton, animated: false)
    }
    
    @objc func showDetailBottomSheet() {
        let bottomSheetVC = PostingDetailBottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }

}


extension PostingDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (postingDetailTableView?.dequeueReusableCell(withIdentifier: "PostingDetailTableViewCell", for: indexPath))!
        
        print("테이블뷰:", postingDetailResponse)
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return UITableView.automaticDimension
        return 200
        }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PostingDetailHeaderView") as! PostingDetailHeaderView
        
        
        return header
        
        }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //(view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.red.withAlphaComponent(0.4)
    }
    
}

extension PostingDetailViewController : GetPostingDetailViewDelegate {
    func didSuccessGetPostingDetailData(_ result: PostingDetailResponse) {
        dismissIndicator()
        self.postingDetailResponse = result
        
    }
    
    func failedToRequest(message: String, code: Int) {
        
    }
    
    
}
