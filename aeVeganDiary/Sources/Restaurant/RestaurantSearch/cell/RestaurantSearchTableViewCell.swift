//
//  RestaurantSearchTableViewCell.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/12.
//

import UIKit


protocol RestaurantSearchTableViewCellDelegate : AnyObject {
    func bookmarkButtonAction(cell: RestaurantSearchTableViewCell)
}

class RestaurantSearchTableViewCell: UITableViewCell {

    weak var delegate : (RestaurantSearchTableViewCellDelegate)?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var roadAddrLabel: UILabel!
    @IBOutlet var lnmAddrLabel: UILabel!
    @IBOutlet var telNoLabel: UILabel!
    @IBOutlet weak var searchBookmarkButton: UIButton!
    @IBAction func bookmarkButtonAction(_ sender: Any) {
        delegate?.bookmarkButtonAction(cell: self)
    }
    
    @IBOutlet weak var restaurantDetailButton: UIButton!
    
    var phoneNum : Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
    }

   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

