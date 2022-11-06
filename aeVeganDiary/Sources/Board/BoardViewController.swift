//
//  BoardViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/06.
//

import UIKit

class BoardViewController: BaseViewController {

    @IBOutlet weak var boardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationTitle(title: "커뮤니티")
        view.backgroundColor = .white
        
        boardTableView.delegate = self
        boardTableView.dataSource = self
    }

}

extension BoardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    
}
