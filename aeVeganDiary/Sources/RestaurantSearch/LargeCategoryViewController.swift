//
//  LargeCategoryViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/08/10.
//

import UIKit
import RxCocoa
import RxSwift


class LargeCategoryViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    let largeCity = ["서울특별시", "경기도", "인천광역시", "강원도", "경상남도", "경상북도", "광주광역시","대구광역시", "대전광역시", "부산광역시", "세종특별자치시"," 울산광역시", "전라남도", "전라북도", "제주특별자치도", "충청남도", "충청북도"]
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LargeCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "LargeCategoryTableViewCell")
    }
    
}

extension LargeCategoryViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return largeCity.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LargeCategoryTableViewCell", for: indexPath)
        cell.textLabel?.text = largeCity[indexPath.row]
        return cell
    }
    
    
    

    
}
