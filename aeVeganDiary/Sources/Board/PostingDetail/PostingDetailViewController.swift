//
//  PostingDetailViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/09.
//

import UIKit

class PostingDetailViewController: BaseViewController, PostingDetailHeaderViewProtocol {
    
    func presentImageView(url: String) {
        let vc = PostingImageDetailViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.imageUrl = url
        self.present(vc, animated: true)
    }
    
    @IBOutlet weak var keyBoardToolBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyBoardToolBarView: UIView!
    @IBOutlet weak var postingDetailTableView: UITableView?
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postCommentButton: UIButton!
    
    @IBAction func postCommentButtonAction(_ sender: Any) {
        var commentText = commentTextField.text
        var commentRequest = CommentRequest(postIdx: postIdx, content: commentText ?? "")
        postCommentDataManager.postComment(userIdx, parameters: commentRequest, delegate: self)
        dismissKeyboard()
    }
    var postingDetailResponse : PostingDetailResponse?
    var commentLists : [CommentsLists]?
    var imageLists : [ImageLists]?
    lazy var getPostingDetailDataManager: GetPostingDetailDataManager = GetPostingDetailDataManager()
    lazy var postCommentDataManager : PostCommentDataManager = PostCommentDataManager()
    lazy var deleteCommentDataManager : DeleteCommentDataManager = DeleteCommentDataManager()
    
    var userIdx = UserDefaults.standard.integer(forKey: "UserId")
    var postIdx : Int = 0
    
    var nickname : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        setDismissButton()
        view.backgroundColor = .white
        postingDetailTableView?.delegate = self
        postingDetailTableView?.dataSource = self
        postingDetailTableView?.register(UINib(nibName: "PostingDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "PostingDetailTableViewCell")
        let headerNib = UINib(nibName: "PostingDetailHeaderView", bundle: nil)
        postingDetailTableView?.register(headerNib, forHeaderFooterViewReuseIdentifier: "PostingDetailHeaderView")
        //postingDetailTableView?.sectionHeaderHeight = UITableView.automaticDimension
        postingDetailTableView?.estimatedRowHeight = UITableView.automaticDimension
        postingDetailTableView?.rowHeight = UITableView.automaticDimension
        
        //getPostingDetailDataManager.getPostingDetailData(137, postIdx: 54, delegate: self)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)

        commentTextField.addTarget(self, action: #selector(isEnableSendButton), for: .editingChanged)
        postCommentButton.isEnabled = false
        postCommentButton.backgroundColor = .lightGray
        
        commentTextField.delegate = self
    }
    
    @objc func isEnableSendButton() {
        if commentTextField.text?.count ?? 0 > 0 {
            postCommentButton.isEnabled = true
            postCommentButton.backgroundColor = .mainGreen
        } else {
            postCommentButton.isEnabled = false
            postCommentButton.backgroundColor = .lightGray
        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        //print(userIdx, postIdx)
        getPostingDetailDataManager.getPostingDetailData(userIdx, postIdx: postIdx, delegate: self)
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
        let bottomSheetVC = PostingDetailMoreSheetViewController()
        bottomSheetVC.postIdx = self.postIdx
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }

}

extension PostingDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentStr = commentTextField.text ?? ""
        guard let strRange = Range(range, in: currentStr) else { return false }
        let changedText = currentStr.replacingCharacters(in: strRange, with: string)
        
        if changedText.count > 200 {
            presentAlert(message: "댓글은 200자까지만 입력할 수 있어요")
        }
        
        return changedText.count <= 200
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
        cell.commentIndex = commentLists?[indexPath.row].commentIdx ?? 0
        
        cell.delegate = self
        
        if(commentLists?[indexPath.row].userIdx==self.userIdx){
            cell.commentDeleteButton.isHidden = false
        } else{
            cell.commentDeleteButton.isHidden = true
        }
        
            //print("테이블뷰:", postingDetailResponse)
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

  }


    //Header
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
            header.imageCollectionViewHeight.constant = 120
            header.labelToCollectionViewHeight.constant = 15
            header.postingContentImageCollectionView.reloadData()
        } else {
            //header.postingContentImageCollectionView.isHidden = true
            header.labelToCollectionViewHeight.constant = 0
            header.imageCollectionViewHeight.constant = 0
        }
        
        header.delegate = self
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
        if(result.userIdx == self.userIdx){
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
        getPostingDetailDataManager.getPostingDetailData(userIdx, postIdx: postIdx, delegate: self)
        postingDetailTableView?.reloadData()
        commentTextField.text = ""
        isEnableSendButton()
    }
}

extension PostingDetailViewController : DeleteCommentViewDelegate{
    func didSuccessDeleteComment(_ result: DeleteCommentResponse) {
        getPostingDetailDataManager.getPostingDetailData(userIdx, postIdx: postIdx, delegate: self)
        presentBottomAlert(message: "삭제가 완료되었습니다.")    }
}


extension PostingDetailViewController : PostingDetailTableViewCellDelegate{
    func commentDeleteButtonAction(commentIndex: Int) {
        presentAlert(title: "정말 삭제하시겠어요?", message: "삭제는 취소할 수 없습니다", isCancelActionIncluded: true, preferredStyle: .alert, handler: {_ in
            
            var deleteCommentRequest = DeleteCommentRequest(commentIdx: commentIndex)
            self.deleteCommentDataManager.deleteComment(self.userIdx, parameters: deleteCommentRequest, delegate: self)

        })
    }
}
