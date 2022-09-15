//
//  RecommCollectionViewCell.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/09/14.
//

import UIKit
import SafariServices

protocol RecommCollectionViewCellDelegate : AnyObject {
    var myUrl : NSURL { get set }
    func recipeButton(cell:RecommCollectionViewCell)
}

class RecommCollectionViewCell: UICollectionViewCell,UIWebViewDelegate {

    var delegate : (RecommCollectionViewCellDelegate)?
    var viewController : RecommCookViewController!
    var innerUrl :String = "https://www.naver.com/"
    var cookRecomm : CookRecomm?
    
    @IBOutlet var noLineView: UIView!
    @IBOutlet var noLabel: UILabel!
    @IBOutlet var hasLineView: UIView!
    @IBOutlet var hasLabel: UILabel!
    @IBOutlet var sadLabel: UILabel!
    @IBOutlet var sadImageView: UIImageView!
    @IBOutlet var recipeButton: UIButton!
    @IBOutlet var hasTableView: UITableView!
    @IBOutlet var noTableView: UITableView!
    @IBOutlet var cellBackgroundView: UIView!
    @IBAction func recipeButton(_ sender: Any) {
        delegate?.recipeButton(cell: self)
        delegate?.myUrl = NSURL(string: innerUrl)!
        //let myUrl = NSURL(string: innerUrl)
        //viewController?.safari(myUrl: myUrl!)
    }
    
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
            
            innerUrl = cookRecomm?.recipeUrl ?? ""
            delegate?.myUrl = NSURL(string: innerUrl)!
            
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
