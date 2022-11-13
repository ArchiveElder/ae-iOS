//
//  BoardHeaderView.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/13.
//

import UIKit

class BoardHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
      
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
