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
    
    let refreshControl = UIRefreshControl()
    
    private lazy var viewSpinner: UIView = {
        let view = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.frame.size.width,
            height: 100)
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationTitle(title: "커뮤니티")
        
        boardTableView.register(UINib(nibName: "BoardTableViewCell", bundle: nil), forCellReuseIdentifier: "BoardTableViewCell")
        refreshControl.endRefreshing()
        boardTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
        
        setBinding()
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
        
        viewModel.refreshControlCompleted.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
        }
        .disposed(by: disposeBag)
        
        viewModel.isLoadingSpinnerAvaliable.subscribe { [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                  let self = self else { return }
            self.boardTableView.tableFooterView = isAvaliable ? self.viewSpinner : UIView(frame: .zero)
        }
        .disposed(by: disposeBag)
        
        boardTableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.boardTableView.contentOffset.y
            let contentHeight = self.boardTableView.contentSize.height

            if offSetY > (contentHeight - self.boardTableView.frame.size.height - 100) {
                self.viewModel.fetchMoreDatas.onNext(())
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func presentDetail(of post: Post) {
        /*guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "MemberDetailViewController") as? MemberDetailViewController else {
            return
        }
        viewModel.selectedMember = member
        present(detailVC, animated: true, completion: nil)*/
    }
    
    @objc private func refreshControlTriggered() {
        viewModel.refreshControlAction.onNext(())
      }

}
