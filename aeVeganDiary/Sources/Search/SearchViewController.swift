//
//  SearchViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/06/03.
//

import UIKit
import RxCocoa
import RxSwift

class SearchViewController: BaseViewController, UITableViewDelegate , UISearchBarDelegate{
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    lazy var searchDataManager : SearchDataManagerDelegate = SearchDataManager()
    
    //MARK: 서버 통신 변수 선언
    var searchResponse: SearchResponse?
    var foods = [Food]()
    var foodDetail = [FoodDetail]()
    var rdate = ""
    var meal = 0
    var foodImage:UIImage? = nil
    
    var shownFoods = [String]()
    let disposeBag = DisposeBag()
    var allFoodsDic : Dictionary = [Int:String]()
    
    var isRegister = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "검색하기")
        searchBar.delegate = self
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
                    $0.name.localizedCaseInsensitiveContains(query) }.map {$0.name}
                    .sorted { ($0.hasPrefix(query) ? 0 : 1) < ($1.hasPrefix(query) ? 0 : 1)}
                self.tableView.reloadData()
            })
        //.addDisposableTo(disposeBag)
    }
    
    //최초 SearchBar 클릭 시
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.dataSource = self
        searchBar.setShowsCancelButton(true, animated:true)
        var searchTerm = searchBar.text
        if(searchTerm!.isEmpty == true){
            tableView.isHidden = false
            self.shownFoods = self.foods.map{$0.name}
            self.tableView.reloadData()
            dismissKeyboardWhenTappedAround()
        }
    }
    
    //SearchBar Text 변경 이벤트
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText==""){
            self.shownFoods = self.foods.map{$0.name}
            self.tableView.reloadData()
            tableView.isHidden = false
            dismissKeyboardWhenTappedAround()
        } else {
            tableView.isHidden = false
            if let recognizers = self.view.gestureRecognizers {
                for recognizer in recognizers {
                    self.view.removeGestureRecognizer(recognizer)
                }
            }
            searchBar
                .rx.text
                .orEmpty
                .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .filter{ !$0.isEmpty }
                .subscribe(onNext: { [unowned self] query in
                    self.shownFoods = self.foods.filter {
                        $0.name.localizedCaseInsensitiveContains(query) }.map {$0.name}
                        .sorted { ($0.hasPrefix(query) ? 0 : 1) < ($1.hasPrefix(query) ? 0 : 1)}
                    self.tableView.reloadData()
                })
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true);
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.tableView.isHidden = true
        dismissKeyboard()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showIndicator()
        searchDataManager.getSearchData(delegate: self)
    }
}


extension SearchViewController : SearchViewDelegate{
    
    func didSuccessGetSearchData(_ result: SearchResponse) {
        dismissIndicator()
        self.searchResponse = result
        self.foods = result.result!.data
    }
    
    func failedToRequest(message: String, code: Int) {
        dismissIndicator()
        presentAlert(message: message)
        if code == 403 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.changeRootViewController(LoginViewController())
            }
        }
        
    }
    
}

extension SearchViewController : UITableViewDataSource {
    /*
    func getData(result: SearchResponse){
        dismissIndicator()
        self.searchResponse = result
        self.foods = result.result.data
    }
     */
    
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
        let currentCell = tableView.cellForRow(at: indexPath)?.textLabel!.text
        let currentIndex = foods.filter{$0.name==currentCell}.map{$0.id}[0]
        print(currentIndex)
        vc.search = 1
        vc.rdate = self.rdate
        vc.meal = self.meal
        vc.id = SearchInput(id:currentIndex)
        vc.foodImage = self.foodImage
        navigationController?.pushViewController(vc, animated: true)
    }
}

