//
//  SearchTableViewCell.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/06.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    
    @IBOutlet var searchResultLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
