//
//  PostingDetailHeaderView.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/11.
//

import UIKit

class PostingDetailHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var postingContentImageCollectionView: UICollectionView!
    @IBOutlet weak var postingIconImageView: UIImageView!
    @IBOutlet weak var postingNicknameLabel: UILabel!
    @IBOutlet weak var postingTitleLabel: UILabel!
    @IBOutlet weak var postingContentsLabel: UILabel!
    @IBOutlet weak var postingLikeButton: UIButton!
    @IBOutlet weak var postingScrapButton: UIButton!
    
    var imagecount : Int = 0
    var imageArray = [ImageLists]()
    override func awakeFromNib() {
        super.awakeFromNib()
        postingContentImageCollectionView.delegate = self
        postingContentImageCollectionView.dataSource = self
        postingContentImageCollectionView.register(UINib(nibName: "PostingDetailImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostingDetailImageCollectionViewCell")
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
