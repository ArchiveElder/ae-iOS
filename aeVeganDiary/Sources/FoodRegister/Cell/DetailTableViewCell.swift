//
//  DetailTableViewCell.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/31.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var nutritionButton: UIButton!
    @IBOutlet weak var measureButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
