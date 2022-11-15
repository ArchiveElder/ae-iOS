//
//  PostingDetailTableViewCell.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/11.
//

import UIKit

protocol PostingDetailTableViewCellDelegate{
    func commentDeleteButtonAction(commentIndex:Int)
}

class PostingDetailTableViewCell: UITableViewCell {
    var commentIndex: Int = 0
    var delegate : PostingDetailTableViewCellDelegate?
    @IBAction func commentDeleteButtonAction(_ sender: Any) {
        self.delegate?.commentDeleteButtonAction(commentIndex: commentIndex)
    }
    @IBOutlet weak var commentDeleteButton: UIButton!
    @IBOutlet weak var commentNicknameLabel: UILabel!
    @IBOutlet weak var commentIconImageView: UIImageView!
    @IBOutlet weak var commentContentLabel: UILabel!
    @IBOutlet weak var commentDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

