//
//  MypageViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/29.
//

import UIKit

class MypageViewController: BaseViewController {
    
    @IBOutlet var myInfoButton: UIButton!
    @IBOutlet var profileImg: UIImageView!
    @IBAction func moveInfo(_ sender: Any) {
        navigationController?.pushViewController(MyInfoViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setNavigationTitle(title: "마이페이지")
        
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        profileImg.layer.borderWidth = 1
        profileImg.layer.borderColor = UIColor.clear.cgColor
        profileImg.clipsToBounds=true
        
    }



}
