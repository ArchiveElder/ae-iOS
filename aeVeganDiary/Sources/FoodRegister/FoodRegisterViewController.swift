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
        
        //NavigationController
        setNavigationTitle(title: "식사 등록하기")
        setBackButton()
        setDoneButton()
        
        // 식단 상세 tableView
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        
        foodImageView.image = foodImage
        
        dismissKeyboardWhenTappedAround()
        
        
    }

}

extension FoodRegisterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        cell.detailImageView.image = foodImage
        cell.amountTextField.text = "1.0"
        cell.measureButton.addTarget(self, action: #selector(showMeasure(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    // 인분/g 바꾸는 메뉴 생성
    @objc func showMeasure(sender : UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "단위를 선택해주세요.", preferredStyle: .actionSheet)

        let gAction = UIAlertAction(title: "g", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("g")
            sender.setTitle("g", for: .normal)
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        })
        
        let perAction = UIAlertAction(title: "인분", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("per")
            sender.setTitle("인분", for: .normal)
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(gAction)
        optionMenu.addAction(perAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
}

extension FoodRegisterViewController {
    func postMeal() {
        dismissIndicator()
        self.dismiss(animated: true)
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
