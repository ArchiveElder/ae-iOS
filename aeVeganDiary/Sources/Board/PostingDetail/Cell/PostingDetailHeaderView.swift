//
//  PostingDetailHeaderView.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/11.
//

import UIKit

class PostingDetailHeaderView: UITableViewHeaderFooterView {
    
    lazy var getPostingDetailDataManager: GetPostingDetailDataManager = GetPostingDetailDataManager()
    lazy var postThumbUpDataManager : PostThumbUpDataManager = PostThumbUpDataManager()
    lazy var deleteThumbUpDataManager : DeleteThumbUpDataManager = DeleteThumbUpDataManager()
    lazy var postScrapDataManager : PostScrapDataManager = PostScrapDataManager()
    lazy var deleteScrapDataManager : DeleteScrapDataManager = DeleteScrapDataManager()
    
    

    @IBOutlet weak var imageCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var postingContentImageCollectionView: UICollectionView!
    @IBOutlet weak var postingIconImageView: UIImageView!
    @IBOutlet weak var postingNicknameLabel: UILabel!
    @IBOutlet weak var postingTitleLabel: UILabel!
    @IBOutlet weak var postingContentsLabel: UILabel!
    @IBOutlet weak var postingThumbUpButton: UIButton!
    @IBOutlet weak var postingCommentButton: UIButton!
    @IBOutlet weak var postingScrapButton: UIButton!
    
    
    @IBAction func thumbUpButtonAction(_ sender: Any) {
        var thumbUpRequest = ThumbUpRequest(postIdx: postIdx)
        if(postingThumbUpButton.isSelected == false){
            postThumbUpDataManager.postThumbUp(userIdx, parameters: thumbUpRequest, delegate: self)
        } else if(postingThumbUpButton.isSelected == true) {
            deleteThumbUpDataManager.deleteThumbUp(userIdx, parameters: thumbUpRequest, delegate: self)
        }
        getPostingDetailDataManager.getPostingDetailData(userIdx, postIdx: postIdx, delegate: self)
    }
    
    @IBAction func scrapButtonAction(_ sender: Any) {
        var scrapRequset = ScrapRequest(postIdx: postIdx)
        if(postingScrapButton.isSelected == false){
            postScrapDataManager.postScrap(userIdx, parameters: scrapRequset, delegate: self)
        } else if (postingScrapButton.isSelected == true){
            deleteScrapDataManager.deleteScrap(userIdx, parameters: scrapRequset, delegate: self)
        }
        getPostingDetailDataManager.getPostingDetailData(userIdx, postIdx: postIdx, delegate: self)
    }
    
    
    var isLiked : Int = 0
    var postIdx = 0
    var userIdx = UserDefaults.standard.integer(forKey: "UserId")
    var imagecount : Int = 0
    var postingDetailResponse : PostingDetailResponse?
    var imageArray = [ImageLists]()
    override func awakeFromNib() {
        super.awakeFromNib()
        postingContentImageCollectionView.delegate = self
        postingContentImageCollectionView.dataSource = self
        postingContentImageCollectionView.register(UINib(nibName: "PostingDetailImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostingDetailImageCollectionViewCell")
        
        //self.translatesAutoresizingMaskIntoConstraints = false
        
        }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

   
}

extension PostingDetailHeaderView : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(imageArray)
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostingDetailImageCollectionViewCell", for: indexPath) as! PostingDetailImageCollectionViewCell
        cell.imageView.load(url: URL(string: imageArray[indexPath.row].imageUrl!)!)
        
        return cell
    }
}

extension PostingDetailHeaderView : GetPostingDetailViewDelegate {
    func didSuccessGetPostingDetailData(_ result: PostingDetailResponse) {
       // print("헤더뷰:" ,result)
        self.postingDetailResponse = result
        postingThumbUpButton.setTitle(String(postingDetailResponse?.thumbupCount ?? 0), for: .normal)
        if(postingDetailResponse?.isLiked == 0){
            postingThumbUpButton.isSelected = false
        } else if(postingDetailResponse?.isLiked == 1){
            postingThumbUpButton.isSelected = true
        }
        if(postingDetailResponse?.isScraped == 0){
            postingScrapButton.isSelected = false
        } else if(postingDetailResponse?.isScraped == 1){
            postingScrapButton.isSelected = true
        }
    }
}

extension PostingDetailHeaderView : PostThumbUpViewDelegate {
    func didSuccessPostThumbUp(_ result: ThumbUpResponse) {
        //print(result)
    }
    
    func failedToRequest(message: String, code: Int) {
        
    }
    
}

extension PostingDetailHeaderView : DeleteThumbUpViewDelegate {
    func didSuccessDeleteThumbUp(_ result: ThumbUpDeleteResponse) {
        //print(result)

    }
}

extension PostingDetailHeaderView : PostScrapViewDelegate{
    func didSuccessPostScrap(_ result: ScrapResponse) {
        //print(result)
    }
}

extension PostingDetailHeaderView : DeleteScrapViewDelegate {
    func didSuccessDeleteScrap(_ result: ScrapDeleteResponse) {
        //print(result)
    }
}
