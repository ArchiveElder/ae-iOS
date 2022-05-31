//
//  FoodRegisterViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/30.
//

import UIKit

class FoodRegisterViewController: BaseViewController {
    var foodImage = UIImage()

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: "식사 등록하기")
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foodImageView.image = foodImage
        
    }
}

extension FoodRegisterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        return cell
    }
    
}
