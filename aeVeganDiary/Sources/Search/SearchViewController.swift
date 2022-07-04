//
//  SearchViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/03.
//

import UIKit
import RxCocoa
import RxSwift

class SearchViewController: BaseViewController, UITableViewDelegate {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    //MARK: 서버 통신 변수 선언
    var searchResponse: SearchResponse?
    var foods = [Food]()
    //var foodNames = [String]()
    var id: CLong?
    var foodIdx: Int?
    
    var shownFoods = [String]()
    let disposeBag = DisposeBag()
    var allFoodsDic : Dictionary = [Int:String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "검색하기")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        setDismissButton()
        setup()
    }

    func setup() {
        tableView.dataSource = self
        searchBar
            .rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter{ !$0.isEmpty }
            .subscribe(onNext: { [unowned self] query in
                self.shownFoods = self.foods.filter {
                    $0.name.hasPrefix(query) }.map {$0.name}
                self.tableView.reloadData()
            })
        //.addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showIndicator()
        SearchDataManager().getSearchData(viewController: self)

    }
}

extension SearchViewController : UITableViewDataSource {
    
    func getData(result: SearchResponse){
        dismissIndicator()
        self.searchResponse = result
        self.foods = result.data
        
    }
    
    func getData2(result: SearchResponse2){
        dismissIndicator()
    }
    
    // MARK: 테이블뷰에 띄우기
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownFoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath)
        //as! SearchTableViewCell
        cell.textLabel?.text = shownFoods[indexPath.row]
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FoodRegisterViewController()
        let inputId = SearchInput(id:3)
    
        vc.search = 1
        SearchDataManager2().requestData(inputId, viewController: self)
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

