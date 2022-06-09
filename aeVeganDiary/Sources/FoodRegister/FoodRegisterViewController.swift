//
//  FoodRegisterViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/30.
//

import UIKit

class FoodRegisterViewController: BaseViewController {
    
    var rdate = ""
    var meal:Int? = nil
    var foodImage = UIImage()
    var amount = 1.0
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mealLabel: UILabel!
    let mealText = ["아침", "점심", "저녁"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
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
        setBackButton()
        
        dateLabel.text = rdate
        mealLabel.text = "\(mealText[meal ?? 0]) 식사"
    }
    
    // 완료 버튼 설정
    func setDoneButton() {
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(done))
        
        self.navigationItem.setRightBarButton(doneButton, animated: false)
    }
    
    @objc func done() {
        showIndicator()
        let input = RegisterInput(rdate: self.rdate, rtime: "08:00", meal: self.meal ?? 0, creates: [Creates(text: "볶음밥", calory: "153", carb: "13", protein: "23", fat: "4", amount: self.amount)])
        RegisterDataManager().registerMeal(input, viewController: self)
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
