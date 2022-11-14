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
    @IBAction func postButtonAction(_ sender: Any) {
        let vc = PostViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    var categoryPickerView = UIPickerView()
    
    let viewModel = BoardViewModel.shared
    let disposeBag = DisposeBag()
    let cellId = "BoardTableViewCell"
    
    let categories = ["전체", "일상", "레시피", "공지", "질문", "꿀팁"]
    var categoryIndex = 0
    
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
        self.view.backgroundColor = .white

        setNavigationTitle(title: "커뮤니티")
        categoryPickerView.delegate = self
        
        boardTableView.delegate = self
        
        boardTableView.register(UINib(nibName: "BoardTableViewCell", bundle: nil), forCellReuseIdentifier: "BoardTableViewCell")
        let headerNib = UINib(nibName: "BoardHeaderView", bundle: nil)
        boardTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "BoardHeaderView")
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
        
        let vc = PostingDetailViewController()
        vc.postIdx = post.postIdx ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func refreshControlTriggered() {
        viewModel.refreshControlAction.onNext(())
    }

    @objc func changeCategory() {
        dismissKeyboard()
        self.viewModel.category = categories[categoryIndex]
        refreshControlTriggered()
    }
}

extension BoardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(changeCategory))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BoardHeaderView") as! BoardHeaderView
        header.categoryTextField.inputView = categoryPickerView
        header.categoryTextField.inputAccessoryView = toolBar
        header.categoryTextField.text = self.viewModel.category
        
        return header
    }
}

extension BoardViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryIndex = row
        //self.viewModel.category = categories[row]
        //refreshControlTriggered()
    }
}
