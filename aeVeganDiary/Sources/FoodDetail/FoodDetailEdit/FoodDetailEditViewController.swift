//
//  FoodDetailEditViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/10/24.
//

import UIKit

class FoodDetailEditViewController: BaseViewController {
    
    lazy var foodDetailEditDataManager: FoodDetailEditDataManagerDelegate = FoodDetailEditDataManager()

    @IBOutlet weak var mealLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var caloryTextField: UITextField!
    @IBOutlet weak var carbTextField: UITextField!
    @IBOutlet weak var proTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    
    @IBOutlet weak var foodImageView: UIImageView!
    var data: DetailRecord?
    var record_id: Int?
    var meal = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        mealLabel.text = data?.text
        dateLabel.text = data?.date
        
        nameTextField.text = data?.text
        caloryTextField.text = data?.cal
        carbTextField.text = data?.carb
        proTextField.text = data?.protein
        fatTextField.text = data?.fat
        amountTextField.text = "\(data?.amount)"
        
        if let url = URL(string: data?.image_url ?? "") {
            foodImageView.load(url: url)
        }
        
        setNavigationTitle(title: "수정하기")
        setDismissButton()
    }
    
    func setDoneButton() {
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(done))
        
        self.navigationItem.setRightBarButton(doneButton, animated: false)
    }
    
    @objc func done() {
        showIndicator()
        let input = FoodDetailEditRequest(recordId: self.record_id ?? 0, text: nameTextField.text, calory: caloryTextField.text, carb: carbTextField.text, protein: proTextField.text, fat: fatTextField.text, rdate: data?.date, rtime: data?.time, amount: data?.amount, meal: self.meal)
        //foodDetailEditDataManager.postFoodDetailEdit(<#T##parameters: FoodDetailEditRequest##FoodDetailEditRequest#>, foodImage: <#T##UIImage#>, delegate: <#T##FoodDetailEditViewDelegate#>)
    }

}

extension FoodDetailEditViewController: FoodDetailEditViewDelegate {
    func didSuccessFoodDetailEdit(_ result: RegisterResponse) {
        dismissIndicator()
        presentAlert(message: "수정 완료")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.dismiss(animated: true)
        }
    }
    
    func failedToRequest(message: String, code: Int) {
        dismissIndicator()
        presentAlert(message: message)
        if code == 403 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.changeRootViewController(LoginViewController())
            }
        }
    }
}
