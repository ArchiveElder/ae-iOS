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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tabBackgroundView.clipsToBounds = true
        tabBackgroundView.layer.cornerRadius = 10
        tabBackgroundView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }

}
