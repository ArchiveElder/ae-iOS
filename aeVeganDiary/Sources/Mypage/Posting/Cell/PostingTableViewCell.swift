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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }

    func updateUI(post: MyPostingLists){
        profileImageView.image = UIImage(named: "profile\(post.icon ?? 0)")
        nicknameLabel.text = post.nickname
        titleLabel.text = post.title
        
        timeLabel.text = calculateTime(dateString: post.createdAt ?? "")
        
        categoryLabel.text = post.boardName
        isPhotoImageView.isHidden = post.hasImg == 1 ? false : true
        likeCountLabel.text = "\(post.thumbupCount ?? 0)"
        commentCountLabel.text = "\(post.commentCount ?? 0)"
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
