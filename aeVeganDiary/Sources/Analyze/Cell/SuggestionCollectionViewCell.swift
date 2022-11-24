//
//  SuggestionCollectionViewCell.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/21.
//

import UIKit

class SuggestionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var problemLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var foodNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
