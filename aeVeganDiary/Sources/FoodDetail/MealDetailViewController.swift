//
//  MealDetailViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/08.
//

import UIKit

class MealDetailViewController: BaseViewController {
    
    lazy var mealDetailDataManager: MealDetailDataManagerDelegate = MealDetailDataManager()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var proLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    
    var record_id: Int?
    let meals = ["아침", "점심", "저녁"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setDismissButton()
        setNavigationTitle(title: "상세 정보")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showIndicator()
        let input = MealDetailRequest(record_id: record_id)
        mealDetailDataManager.getMealDetail(input, delegate: self)
    }
}

extension MealDetailViewController: MealDetailViewDelegate {
    func didSuccessGetMealDetail(_ result: MealDetailResponse) {
        dismissIndicator()
        let data = result.result?.data[0]
        titleLabel.text = data?.text
        dateLabel.text = "\(data?.date ?? "") \(data?.time ?? "")"
        textLabel.text = data?.text
        calLabel.text = data?.cal
        carbLabel.text = data?.carb
        proLabel.text = data?.protein
        fatLabel.text = data?.fat
        if let url = URL(string: data?.image_url ?? "") {
            foodImageView.load(url: url)
        }
    }
    
    func failedToRequest(message: String, code: Int) {
        dismissIndicator()
        presentAlert(message: message)
        if code == 403 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.changeRootViewController(LoginViewController())
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.dismiss(animated: true)
            }
        }
    }
}
