//
//  BaseViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/28.
//

import UIKit

class BaseViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .white
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        view.backgroundColor = .gray4
        navigationController?.navigationBar.isTranslucent = false
        
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationController?.navigationBar.shadowImage = UIImage()
        //navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func setNavigationTitle(title: String) {
        let titleview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleview.addSubview(titleLabel)
        self.navigationItem.titleView = titleview
    }
    
    @objc func popToVC() {
        navigationController?.popViewController(animated: true)
    }
    
}
