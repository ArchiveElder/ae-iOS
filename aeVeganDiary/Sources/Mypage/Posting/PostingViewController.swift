//
//  PostingViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/08.
//

import UIKit
import RxSwift
import RxCocoa

class PostingViewController: BaseViewController, UITableViewDelegate{
    
    @IBOutlet weak var postingTableView: UITableView!
    let viewModel = PostingViewModel.shared
    let disposeBag = DisposeBag()
    let cellId = "PostingTableViewCell"
    let refreshControl = UIRefreshControl()
    
    
    private lazy var viewSpinner : UIView = {
        let view = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.frame.size.width,
            height:100)
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setNavigationTitle(title: "내가 쓴 글")
        
        postingTableView.delegate = self
        
        postingTableView.register(UINib(nibName: "PostingTableViewCell", bundle: nil), forCellReuseIdentifier: "PostingTableViewCell")
        refreshControl.endRefreshing()
        postingTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
        
        setBinding()
    }
    
    private func setBinding(){
        viewModel.posts
            .observe(on: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .bind(to: postingTableView.rx.items(cellIdentifier: cellId, cellType: PostingTableViewCell.self)) {
                index, item, cell in
                cell.updateUI(post: item)
            }
            .disposed(by: disposeBag)
        
        postingTableView.rx.modelSelected(PostingLists.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] post in self?.presentDetail(of: post)
            })
            .disposed(by: disposeBag)
        
        viewModel.refreshControlCompleted.subscribe{ [weak self] _ in
            guard let self = self else {return}
            self.refreshControl.endRefreshing()
        }
        .disposed(by: disposeBag)
        
        viewModel.isLoadingSpinnerAvaliable.subscribe{ [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                  let self = self else {return}
            self.postingTableView.tableFooterView = isAvaliable ?
            self.viewSpinner : UIView(frame: .zero)
        }
        .disposed(by: disposeBag)
        
        postingTableView.rx.didScroll.subscribe{ [weak self] _ in
            guard let self = self else {return}
            let offSetY = self.postingTableView.contentOffset.y
            let contentHeight = self.postingTableView.contentSize.height
            
            if offSetY > (contentHeight - self.postingTableView.frame.size.height - 100) {
                self.viewModel.fetchMoreDatas.onNext(())
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func presentDetail(of post : PostingLists) {
        let vc = PostingDetailViewController()
        vc.postIdx = post.postIdx ?? 0
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.view.backgroundColor = .white
        self.present(nav, animated: true)
    }
    
    @objc private func refreshControlTriggered() {
        viewModel.refreshControlAction.onNext(())
    }
    
}


