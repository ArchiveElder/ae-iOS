//
//  PostingTableViewCell.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/18.
//

import UIKit
import RxSwift
import RxCocoa

class PostingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var isPhotoImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
