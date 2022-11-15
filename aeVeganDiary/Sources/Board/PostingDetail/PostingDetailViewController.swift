//
//  PostingDetailViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/09.
//

import UIKit

class PostingDetailViewController: BaseViewController {
    
    @IBOutlet weak var keyBoardToolBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyBoardToolBarView: UIView!
    @IBOutlet weak var postingDetailTableView: UITableView?
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postCommentButton: UIButton!
    
    @IBAction func postCommentButtonAction(_ sender: Any) {
        var commentText = commentTextField.text
        var commentRequest = CommentRequest(postIdx: postIdx, content: commentText ?? "")
        postCommentDataManager.postComment(userId, parameters: commentRequest, delegate: self)
        dismissKeyboard()
        commentTextField.text = ""
    }
    var postingDetailResponse : PostingDetailResponse?
    var commentLists : [CommentsLists]?
    var imageLists : [ImageLists]?
    lazy var getPostingDetailDataManager: GetPostingDetailDataManager = GetPostingDetailDataManager()
    lazy var postCommentDataManager : PostCommentDataManager = PostCommentDataManager()
    
    var userId = UserDefaults.standard.integer(forKey: "UserId")
    var postIdx : Int = 0
    
    var nickname : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        setDismissButton()
        
        postingDetailTableView?.delegate = self
        postingDetailTableView?.dataSource = self
        postingDetailTableView?.register(UINib(nibName: "PostingDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "PostingDetailTableViewCell")
        let headerNib = UINib(nibName: "PostingDetailHeaderView", bundle: nil)
        postingDetailTableView?.register(headerNib, forHeaderFooterViewReuseIdentifier: "PostingDetailHeaderView")
        //postingDetailTableView?.sectionHeaderHeight = UITableView.automaticDimension
        postingDetailTableView?.estimatedRowHeight = 110
        postingDetailTableView?.rowHeight = 110
        
        //getPostingDetailDataManager.getPostingDetailData(137, postIdx: 54, delegate: self)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.keyBoardToolBarView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height+40)
                }
            )
        }
    }
    
    @objc func keyboardDown() {
        self.keyBoardToolBarView.transform = .identity
    }
    
    /*
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            if isKeyboardShowing {
                //keyboardDismissButton.isHidden = false
            } else {
                //keyboardDismissButton.isHidden = true
            }
            
            keyBoardToolBarConstraint.constant = isKeyboardShowing ? keyboardFrame.cgRectValue.height - view.safeAreaInsets.bottom : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    */
    
    override func viewDidAppear(_ animated: Bool) {
        //print(userId, postIdx)
        getPostingDetailDataManager.getPostingDetailData(userId, postIdx: postIdx, delegate: self)
    }
    
    /*
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let headerView = postingDetailTableView!.tableHeaderView {
            print("프레임:", headerView.frame)
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                postingDetailTableView!.tableHeaderView = headerView
            }
        }
    }
*/
    
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
        let bottomSheetVC = PostingDetailMoreSheetViewController()
        bottomSheetVC.postIdx = self.postIdx
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }

}


extension PostingDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postingDetailResponse?.commentCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (postingDetailTableView?.dequeueReusableCell(withIdentifier: "PostingDetailTableViewCell", for: indexPath)) as! PostingDetailTableViewCell
        
        
        cell.commentNicknameLabel.text = commentLists?[indexPath.row].nickname
        cell.commentIconImageView.image = UIImage(named: "profile\(commentLists?[indexPath.row].icon ?? 0)")
        cell.commentContentLabel.text = commentLists?[indexPath.row].content
        cell.commentDateLabel.text = commentLists?[indexPath.row].date
        print("테이블뷰:", postingDetailResponse)
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return UITableView.automaticDimension
        return UITableView.automaticDimension
        }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PostingDetailHeaderView") as! PostingDetailHeaderView
        var likeButtonCount : Int = postingDetailResponse?.thumbupCount ?? 0
        var commentButtonCount : Int = postingDetailResponse?.commentCount ?? 0
        header.postingNicknameLabel.text = postingDetailResponse?.nickname
        header.postingTitleLabel.text = postingDetailResponse?.title
        header.postingContentsLabel.text = postingDetailResponse?.content
        header.postingIconImageView.image = UIImage(named: "profile\(postingDetailResponse?.icon ?? 0)")
        header.postingThumbUpButton.setTitle(String(likeButtonCount), for: .normal)
        header.postingCommentButton.setTitle(String(commentButtonCount), for: .normal)
        if(postingDetailResponse?.liked == false || postingDetailResponse?.liked == nil){
            header.postingThumbUpButton.isSelected = false
        } else {
            header.postingThumbUpButton.isSelected = true
        }
        
        if(postingDetailResponse?.scraped == false || postingDetailResponse?.scraped == nil){
            header.postingScrapButton.isSelected = false
        } else if(postingDetailResponse?.scraped == true){
            header.postingScrapButton.isSelected = true
        }
        header.postIdx = postIdx
        header.isLiked = ((postingDetailResponse?.liked) != nil)
        header.imageArray = imageLists ?? []
        if(imageLists?.isEmpty == false) {
            header.postingContentImageCollectionView.isHidden = false
            header.imageCollectionViewHeight.constant = 110
            header.labelToCollectionViewHeight.constant = 15
            header.postingContentImageCollectionView.reloadData()
        } else {
            //header.postingContentImageCollectionView.isHidden = true
            header.labelToCollectionViewHeight.constant = 0
            header.imageCollectionViewHeight.constant = 0
        }
        
        header.reloadInputViews()
        return header
        
        
        }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //(view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.red.withAlphaComponent(0.4)
    }
    
}

extension PostingDetailViewController : GetPostingDetailViewDelegate {
    func didSuccessGetPostingDetailData(_ result: PostingDetailResponse) {
        dismissIndicator()
        print(result)
        self.postingDetailResponse = result
        self.commentLists = result.commentsLists
        self.imageLists = result.imagesLists
        self.setNavigationTitle(title: result.boardName ?? "")
        
        //자신의 글일 때만 더보기 버튼 보이도록
        if(result.userIdx == self.userId){
            setMoreButton()
        }
        
        postingDetailTableView?.reloadData()
    }
    
    func failedToRequest(message: String, code: Int) {
        
    }
    
}

extension PostingDetailViewController : PostCommentViewDelegate{
    func didSuccessPostComment(_ result: CommentResponse) {
        print("댓글 등록 성공")
        getPostingDetailDataManager.getPostingDetailData(userId, postIdx: postIdx, delegate: self)
        postingDetailTableView?.reloadData()
    }
}
