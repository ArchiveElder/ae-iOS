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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitle(title: "식사 등록하기")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foodImageView.image = foodImage
    }
}
