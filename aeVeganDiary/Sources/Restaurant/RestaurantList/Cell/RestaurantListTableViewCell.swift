//
//  RestaurantListTableViewCell.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/18.
//

import UIKit

class RestaurantListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var roadAddrLabel: UILabel!
    @IBOutlet weak var lnmAddrLabel: UILabel!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
