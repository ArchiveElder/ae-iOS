//
//  PostingViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/08.
//

import UIKit

class PostingViewController: UIViewController {

    @IBOutlet weak var myPostingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        myPostingTableView.delegate = self
        myPostingTableView.dataSource = self
        myPostingTableView.register(UINib(nibName: "MyPostingTableViewCell", bundle: nil), forCellReuseIdentifier: "MyPostingTableViewCell")
    }

}


extension PostingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = (myPostingTableView?.dequeueReusableCell(withIdentifier: "MyPostingTableViewCell", for: indexPath)) as! MyPostingTableViewCell
        
        return cell
    }
    
    
}
