//
//  CookRecommViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/11.
//

import UIKit
import RxCocoa
import RxSwift

class CookRecommViewController: BaseViewController, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var recommButton: UIButton!
    
    @IBAction func recommResult(_ sender: Any) {
        CookRecommDataManager().requestData(ingreInput, viewController: self)
        
    }
    
    var searchBarFocused = false
    var selectedIngre = [String?]()
    var ingreInput = IngreInput(ingredients: ["감자", "두부", "설탕"])
    
    //MARK: 서버 통신 변수 선언
    var ingreResponse: IngreResponse?
    var ingre = [Ingre]()
    var cookRecommResponse: CookRecommResponse?
    var cookRecomm = [CookRecomm?]()
    //var id : CLong?
    //var foodIdx: Int?
    
    var shownFoods = [String]()
    var disposeBag = DisposeBag()
    var allFoodsDic : Dictionary = [Int:String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: "CookRecommTableViewCell", bundle: nil), forCellReuseIdentifier: "CookRecommTableViewCell")
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
                self.shownFoods = self.ingre.filter {
                    $0.name.hasPrefix(query) }.map {$0.name}
                self.tableView.reloadData()
            })
        //.addDisposableTo(disposeBag)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showIndicator()
        IngreDataManager().getIngreData(viewController: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
    }
    
    
}

extension CookRecommViewController : UITableViewDataSource{
    func getData(result: IngreResponse){
        dismissIndicator()
        self.ingreResponse = result
        self.ingre = result.data
    }
    
    func getRecomm(result: CookRecommResponse){
        dismissIndicator()
        self.cookRecommResponse = result
        self.cookRecomm = result.foodDto
        print(cookRecomm)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownFoods.count
    }
    
    
    //셀 하나하나에 검색 목록 띄워줌
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CookRecommTableViewCell", for: indexPath)
        cell.textLabel?.text = shownFoods[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //음식 선택 시
        let currentCell = tableView.cellForRow(at: indexPath)?.textLabel!.text
        print(currentCell)
        //selectedIngre.append(currentCell)
        //ingreTableView.reloadData()
        tableView.isHidden = true
        //print(selectedIngre)
        //var currentIndex = foods.filter{$0.name==currentCell}.map{$0.id}[0]
        //print(currentIndex)
        //let inputId = SearchInput(id:currentIndex)
        //vc.search = 1
        //vc.id = SearchInput(id:currentIndex)
        //navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
