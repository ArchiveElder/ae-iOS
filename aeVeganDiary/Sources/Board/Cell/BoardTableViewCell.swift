//
//  BoardTableViewCell.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/06.
//

import UIKit
import RxSwift
import RxCocoa

class BoardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var isPhotoImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        // cell reuse 시에 초기화되도록 작업하기
        //avatarImage.image = nil
        disposeBag = DisposeBag()
    }
    
    func updateUI(post: Post) {
        categoryLabel.text = post.groupName
        nicknameLabel.text = post.nickname
        titleLabel.text = post.title
        bookmarkButton.isSelected = post.isScraped == 1 ? true : false
    }
}
