//
//  PostingImageDetailViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/21.
//

import UIKit

class PostingImageDetailViewController: UIViewController {

    @IBAction func XButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var XButton: UIButton!
    @IBOutlet weak var detailImageView: UIImageView!
    var imageUrl : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let url = URL(string: imageUrl ?? "") {
            detailImageView.load(url: url)
        }
        print(imageUrl)
        //detailImageView.load(url: URL(string: imageUrl) ?? URL(string: "")!)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if let url = URL(string: imageUrl ?? "") {
            detailImageView.load(url: url)
        }
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
