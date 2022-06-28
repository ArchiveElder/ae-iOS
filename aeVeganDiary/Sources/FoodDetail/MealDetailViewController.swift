//
//  MealDetailViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/08.
//

import UIKit

class MealDetailViewController: BaseViewController {

    @IBOutlet var kcalView: UIView!
    @IBOutlet var nutrView: UIView!
    
    var record_id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setBackButton()
        setNavigationTitle(title: "상세 정보")
        
        kcalView.layer.cornerRadius = 8
        nutrView.layer.cornerRadius = 8
        kcalView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMinXMinYCorner)
        nutrView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMinXMinYCorner)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showIndicator()
        
    }
}

extension MealDetailViewController {
    func getData(result: MealDetailResponse) {
        dismissIndicator()
    }
    
    func failedToRequest(message: String) {
        dismissIndicator()
        presentAlert(message: message)
    }
}
