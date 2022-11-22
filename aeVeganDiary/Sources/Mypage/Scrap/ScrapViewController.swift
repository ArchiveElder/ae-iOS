//
//  ScrapViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/08.
//

import UIKit
import RxSwift
import RxCocoa

class ScrapViewController: BaseViewController, UITableViewDelegate {

    @IBOutlet weak var scrapTableView: UITableView!
    
    let viewModel = ScrapViewModel.shared
    let disposeBag = DisposeBag()
    let cellId = "MyScrapTableViewCell"
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
        setNavigationTitle(title: "스크랩한 글")
        
        scrapTableView.delegate = self
        
        scrapTableView.register(UINib(nibName: "MyScrapTableViewCell", bundle: nil), forCellReuseIdentifier: "MyScrapTableViewCell")
        refreshControl.endRefreshing()
        scrapTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
        
        scrapTableView.reloadData()

        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        //viewModel.fetchData(page: 0, isRefreshControl: true)
        //refreshControlTriggered()
    }
    
    private func setBinding(){
        viewModel.posts
            .observe(on: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .bind(to: scrapTableView.rx.items(cellIdentifier: cellId, cellType: MyScrapTableViewCell.self)) {
                index, item, cell in
                cell.updateUI(post: item)
            }
            .disposed(by: disposeBag)
        
        scrapTableView.rx.modelSelected(MyScrapLists.self)
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
            self.scrapTableView.tableFooterView = isAvaliable ?
            self.viewSpinner : UIView(frame: .zero)
        }
        .disposed(by: disposeBag)
        
        scrapTableView.rx.didScroll.subscribe{ [weak self] _ in
            guard let self = self else {return}
            let offSetY = self.scrapTableView.contentOffset.y
            let contentHeight = self.scrapTableView.contentSize.height
            
            if offSetY > (contentHeight - self.scrapTableView.frame.size.height - 100) {
                self.viewModel.fetchMoreDatas.onNext(())
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func presentDetail(of post : MyScrapLists) {
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



