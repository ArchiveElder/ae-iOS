//
//  MypageViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/05/29.
//

import UIKit

class MypageViewController: UIViewController {

    @IBOutlet var profile_img: UIImageView!
    @IBOutlet var badge_img: UIImageView!
    @IBOutlet var earth_img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profile_img.image = UIImage(named: "img1.jpeg")
        badge_img.image = UIImage(named: "tree.png")
        earth_img.image = UIImage(named: "earth.png")
        // Do any additional setup after loading the view.
        
        profile_img.layer.cornerRadius = profile_img.frame.height/2
        profile_img.layer.borderWidth = 1
        profile_img.layer.borderColor = UIColor.clear.cgColor
        profile_img.clipsToBounds=true
        
        badge_img.layer.cornerRadius = badge_img.frame.height/2
        badge_img.layer.borderWidth = 1
        badge_img.layer.borderColor = UIColor.clear.cgColor
        badge_img.clipsToBounds=true
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
