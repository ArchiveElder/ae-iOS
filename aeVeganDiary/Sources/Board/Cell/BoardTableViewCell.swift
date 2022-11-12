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
        categoryLabel.text = post.boardName
        profileImageView.image = UIImage(named: "profile\(post.icon ?? 0)")
        nicknameLabel.text = post.nickname
        titleLabel.text = post.title
        
        timeLabel.text = calculateTime(dateString: post.createdAt ?? "")
        
        bookmarkButton.isSelected = post.isScraped == 1 ? true : false
        isPhotoImageView.isHidden = post.hasImg == 1 ? false : true
        likeCountLabel.text = "\(post.likeCnt ?? 0)"
        commentCountLabel.text = "\(post.commentCnt ?? 0)"
    }
    
    func calculateTime(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        let current = Date()
        
        let date = dateFormatter.date(from: dateString) ?? Date()
        let timeCalculate = current.timeIntervalSinceReferenceDate - (date.timeIntervalSinceReferenceDate)

        let time: Int = Int(abs(timeCalculate))
        if time >= 0 && time < 60 {
            return "\(time)초 전"
        } else if time >= 60 && time < 3600 {
            return "\(time / 60)분 전"
        } else if time >= 3600 && time < 86400 {
            return "\(time / 3600)시간 전"
        } else if time >= 86400 && time < 604800 {
            return "\(time / 86400)일 전" // 7일 미만일 때
        } else {
            // 7일 이상일 때
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            return dateFormatter.string(from: date)
        }
    }
}
