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
    
    @IBOutlet var name: UILabel!
    @IBOutlet var category: UILabel!
    @IBOutlet var roadAddr: UILabel!
    @IBOutlet var lnmAddr: UILabel!
    @IBOutlet var telNo: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    @IBOutlet var bookmarkButton: UIButton!
    @IBAction func bookmarkButtonAction(_ sender: Any) {
        delegate?.bookmarkButtonAction(cell: self)
    }
    
    var phoneNum : Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
    }

   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

