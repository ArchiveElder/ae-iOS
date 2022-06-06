//
//  RegisterCollectionViewCell.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/30.
//

import UIKit

class RegisterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var registerMealButton: UIButton!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // backgroundView 아래 왼쪽, 아래 오른쪽 둥글게
        cellBackgroundView.clipsToBounds = true
        cellBackgroundView.layer.cornerRadius = 10
        cellBackgroundView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }

}
