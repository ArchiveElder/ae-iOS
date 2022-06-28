//
//  BodyInitViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/09.
//

import UIKit

class BodyInitViewController: BaseViewController {

    @IBAction func doneButton(_ sender: Any) {
        self.changeRootViewController(BaseTabBarController())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setBackButton()
        setNavigationTitle(title: "프로필 설정")
        dismissKeyboardWhenTappedAround()
    }

}
