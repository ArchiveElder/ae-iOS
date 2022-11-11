//
//  BoardViewController.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/06.
//

import UIKit
import RxSwift
import RxCocoa

class BoardViewController: BaseViewController {

    @IBOutlet weak var boardTableView: UITableView!
    
    let viewModel = BoardViewModel.shared
    let disposeBag = DisposeBag()
    let cellId = "BoardTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationTitle(title: "커뮤니티")
        view.backgroundColor = .white
        //boardTableView.register(UINib(nibName: "BoardTableViewCell", bundle: nil), forCellReuseIdentifier: "BoardTableViewCell")
        
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.reloadData()
    }
    
    
    private func setBinding() {
        //boardTableView.rx.setDelegate(self).disposed(by: bag)
        // tableView datasource -- 데이터 개수, 셀에 들어갈 내용
        viewModel.posts
            .observe(on: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .bind(to: boardTableView.rx.items(cellIdentifier: cellId, cellType: BoardTableViewCell.self)) { index, item, cell in
                cell.updateUI(post: item)
            }
            .disposed(by: disposeBag)
        
        // tableView delegate
        // tableView.rx.itemSelected -> indexPath
        boardTableView.rx.modelSelected(Post.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] post in
                self?.presentDetail(of: post)
            })
            .disposed(by: disposeBag)
    }
    
    private func presentDetail(of post: Post) {
        /*guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "MemberDetailViewController") as? MemberDetailViewController else {
            return
        }
        viewModel.selectedMember = member
        present(detailVC, animated: true, completion: nil)*/
    }

}
