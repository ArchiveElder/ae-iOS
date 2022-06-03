//
//  TabCollectionViewCell.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/30.
//

import UIKit

class TabCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tabBackgroundView: UIView!
    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var nullView: UIView!
    @IBOutlet weak var kcalLabel: UILabel!
    @IBOutlet weak var kcal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 뷰 왼쪽 위, 오른쪽 위 둥글게 하는 코드
        tabBackgroundView.clipsToBounds = true
        tabBackgroundView.layer.cornerRadius = 10
        tabBackgroundView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }

}
