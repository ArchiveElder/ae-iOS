//
//  MypageViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/29.
//

import UIKit

class MypageViewController: BaseViewController {
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        UserManager.shared.jwt = ""
        //UserDefaults.standard.setValue("", forKey: "UserJwt")
        let vc = LoginViewController()
        let navController = UINavigationController(rootViewController: vc)
        //navController.view.backgroundColor = .white
        //navController.navigationBar.isTranslucent = false
        self.changeRootViewController(navController)
    }
    
    @IBAction func bookmarkButtonAction(_ sender: Any) {
        let vc = BookmarkViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var myInfoButton: UIButton!
    @IBOutlet var profileImageView: UIImageView!
    @IBAction func moveInfo(_ sender: Any) {
        let vc = MyInfoViewController()
        vc.age = myInfoResponse?.age ?? 0
        vc.height = myInfoResponse?.height ?? "0"
        vc.weight = myInfoResponse?.weight ?? "0"
        vc.activity = myInfoResponse?.activity ?? 0
        // 화면 push 할 때 하단 탭바 가리는 코드
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: 서버 통신 변수 선언
    var myInfoResponse : MyInfoResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setNavigationTitle(title: "마이페이지")
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.clear.cgColor
        profileImageView.clipsToBounds=true
        
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
        
        nicknameLabel.text = result.name
        profileImageView.image = UIImage(named: "profile\(result.icon)")
        profileImageView.borderWidth = 1
        profileImageView.borderColor = .lightGray
    }
}
