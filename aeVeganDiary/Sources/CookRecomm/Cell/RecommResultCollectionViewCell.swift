//
//  RecommResultCollectionViewCell.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/03.
//

import UIKit

class RecommResultCollectionViewCell: UICollectionViewCell {

    var test: [String] = ["One", "Two", "Three"]
    
    @IBOutlet var recommNameLabel: UILabel!
    @IBOutlet var recommHasTableView: UITableView!
    @IBOutlet var recommNoTableView: UITableView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        recommHasTableView.delegate = self
        recommHasTableView.dataSource = self
        recommNoTableView.delegate = self
        recommNoTableView.dataSource = self
        
    }

}

extension RecommResultCollectionViewCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hasTableViewCell", for: indexPath) as! hasTableViewCell
        cell.textLabel1?.text = test[0]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

