//
//  PostingDetailHeaderView.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/11.
//

import UIKit

class PostingDetailHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var postingIconImageView: UIImageView!
    @IBOutlet weak var postingNicknameLabel: UILabel!
    @IBOutlet weak var postingTitleLabel: UILabel!
    @IBOutlet weak var postingContentsLabel: UILabel!
    @IBOutlet weak var postingLikeButton: UIButton!
    @IBOutlet weak var postingScrapButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
            }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
      
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


}
