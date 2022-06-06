//
//  MealCollectionViewCell.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/06/04.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var mealTableView: UITableView!
    
    var records: Records?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackgroundView.clipsToBounds = true
        cellBackgroundView.layer.cornerRadius = 10
        cellBackgroundView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        
        mealTableView.delegate = self
        mealTableView.dataSource = self
        let nibName = UINib(nibName: "MealTableViewCell", bundle: nil)
        mealTableView.register(nibName, forCellReuseIdentifier: "MealTableViewCell")
    }

}

extension MealCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records?.record.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as! MealTableViewCell
        cell.timeLabel.text = records?.record[indexPath.row].rtime
        cell.foodNameLabel.text = records?.record[indexPath.row].text
        cell.calLabel.text = records?.record[indexPath.row].calory
        return cell
    }
    
    
}