//
//  MypageViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/29.
//

import UIKit

class MypageViewController: BaseViewController {
    
    @IBOutlet var Nickname: UILabel!
    @IBOutlet var myInfoButton: UIButton!
    @IBOutlet var profileImg: UIImageView!
    @IBAction func moveInfo(_ sender: Any) {
        let vc = MyInfoViewController()
        vc.age = myInfoResponse?.age ?? 0
        vc.height = myInfoResponse?.height ?? "0"
        vc.weight = myInfoResponse?.weight ?? "0"
        vc.activity = myInfoResponse?.activity ?? 0
        //vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: 서버 통신 변수 선언
    var myInfoResponse : MyInfoResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setNavigationTitle(title: "마이페이지")
        
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        profileImg.layer.borderWidth = 1
        profileImg.layer.borderColor = UIColor.clear.cgColor
        profileImg.clipsToBounds=true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showIndicator()
        MyInfoDataManager().getMyInfoData(viewController: self)
    }

}

//MARK: 서버 통신
extension MypageViewController {
    func getData(result: MyInfoResponse){
        dismissIndicator()
        self.myInfoResponse = result
        
        Nickname.text = result.name
    }
}
