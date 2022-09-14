//
//  RecommCollectionViewCell.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/09/14.
//

import UIKit

class RecommCollectionViewCell: UICollectionViewCell {

    @IBOutlet var foodLabel: UILabel!
    @IBOutlet var hasTableView: UITableView!
    @IBOutlet var noTableView: UITableView!
    @IBOutlet var cellBackgroundView: UIView!
    
    var cookRecomm : CookRecomm?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackgroundView.clipsToBounds = true
        cellBackgroundView.layer.cornerRadius = 10
        cellBackgroundView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        
        hasTableView.delegate = self
        hasTableView.dataSource = self
        let hasNibName = UINib(nibName: "hasTableViewCell", bundle: nil)
        hasTableView.register(hasNibName, forCellReuseIdentifier: "hasTableViewCell")
        
        noTableView.delegate = self
        noTableView.dataSource = self
        let noNibName = UINib(nibName: "noTableViewCell", bundle: nil)
        noTableView.register(noNibName, forCellReuseIdentifier: "noTableViewCell")
        
    }

}

extension RecommCollectionViewCell : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == hasTableView){
            return cookRecomm?.has.count ?? 0
        } else {
            return cookRecomm?.no.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == hasTableView) {
            //foodLabel.text = cookRecomm?.food
            let cell = hasTableView.dequeueReusableCell(withIdentifier: "hasTableViewCell", for: indexPath) as! hasTableViewCell
            cell.hasIngreLabel.text = cookRecomm?.has[indexPath.row]
            cell.hasIngreLabel.textColor = .darkGray
            cell.hasIngreLabel.font = UIFont.systemFont(ofSize: 15)
            return cell
        } else {
            let cell = noTableView.dequeueReusableCell(withIdentifier: "noTableViewCell", for: indexPath) as! noTableViewCell
            cell.noIngreLabel.text = cookRecomm?.no[indexPath.row]
            cell.noIngreLabel.textColor = .darkGray
            cell.noIngreLabel.font = UIFont.systemFont(ofSize: 15)
            return cell
        }
       
    }
    
    
}
