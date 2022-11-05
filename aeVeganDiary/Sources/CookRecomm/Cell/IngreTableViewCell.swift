//
//  ingreTableViewCell.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/01.
//

import UIKit

protocol IngreTableviewCellDelegate : AnyObject{
    func didTapIngreCheckButton(with ingreLabel:String, with ingreSelected:Bool)
    func didTapIngreDeleteButton(with ingreLabel:String)
}

class IngreTableViewCell: UITableViewCell {

    weak var delegate : IngreTableviewCellDelegate?
    var ingreSelected : Bool = false
    var checkedLabel : String = ""
    //var index : Int?
    
    @IBAction func didTapIngreDeleteButton(_ sender: Any) {
        checkedLabel = ingreLabel.text!
        delegate?.didTapIngreDeleteButton(with: checkedLabel)
    }
    @IBOutlet weak var ingreCheckButton: UIButton!
    @IBAction func didTapIngreCheckButton(_ sender: UIButton) {
        //guard let idx = index else {return}
        if(ingreCheckButton.isSelected==true){
            ingreCheckButton.isSelected = false
            ingreSelected = false
            checkedLabel = ingreLabel.text!
        }else{
            ingreCheckButton.isSelected = true
            ingreSelected = true
            checkedLabel = ingreLabel.text!
        }
        //sender.isSelected.toggle()
        delegate?.didTapIngreCheckButton(with: checkedLabel, with: ingreSelected)
    }
    
    @IBOutlet var ingreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ingreCheckButton.addTarget(self, action: #selector(didTapIngreCheckButton(_:)), for: .touchUpInside)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /*
    override func prepareForReuse() {
        if(ingreSelected==false){
            self.ingreCheckButton.isSelected = false
        }else if(ingreSelected == true){
            self.ingreCheckButton.isSelected=true
        }
    }
     */
}
