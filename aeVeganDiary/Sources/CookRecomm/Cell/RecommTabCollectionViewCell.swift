//
//  RecommTabCollectionViewCell.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/09/14.
//

import UIKit

class RecommTabCollectionViewCell: UICollectionViewCell {

    @IBOutlet var tabLabel: UILabel!
    @IBOutlet var recommTabBackgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 뷰 왼쪽 위, 오른쪽 위 둥글게 하는 코드
        recommTabBackgroundView.clipsToBounds = true
        recommTabBackgroundView.layer.cornerRadius = 10
        recommTabBackgroundView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }

}
