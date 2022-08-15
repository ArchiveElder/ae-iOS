//
//  RestaurantSearchTableViewCell.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/12.
//

import UIKit

class RestaurantSearchTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var roadAddr: UILabel!
    @IBOutlet var lnmAddr: UILabel!
    @IBOutlet var telNo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
