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
    @IBOutlet var ingreTableView: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var recommButton: UIButton!
    
    //음식 찾기 API 이벤트
    @IBAction func recommResult(_ sender: Any) {
        var ingreInput = IngreInput(ingredients: ingreArr)
        CookRecommDataManager().requestData(ingreInput, viewController: self)
    }
    
    var searchBarFocused = false
    var ingreArr = [String]()
    
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
        searchTableView.isHidden = true
        searchTableView.dataSource = self
        searchTableView.delegate = self
        ingreTableView.dataSource = self
        ingreTableView.delegate = self
        searchBar.delegate = self
        searchTableView.register(UINib(nibName: "CookRecommTableViewCell", bundle: nil), forCellReuseIdentifier: "CookRecommTableViewCell")
        ingreTableView.register(UINib(nibName: "ingreTableViewCell", bundle: nil), forCellReuseIdentifier: "ingreTableViewCell")
        setDismissButton()
        setup()
    }
    
    func setup() {
        searchTableView.dataSource = self
        searchBar
            .rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter{ !$0.isEmpty }
            .subscribe(onNext: { [unowned self] query in
                self.shownFoods = self.ingre.filter {
                    $0.name.hasPrefix(query) }.map {$0.name}
                self.searchTableView.reloadData()
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
            searchTableView.isHidden = true
        } else {
            searchTableView.isHidden = false
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
        var count : Int = 0
        if tableView == searchTableView {
            count = shownFoods.count
        } else if tableView == ingreTableView {
            count = ingreArr.count
        }
        return count
    }
    
    
    //셀 하나하나에 검색 목록 띄워줌
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == searchTableView {
            let cell = searchTableView.dequeueReusableCell(withIdentifier: "CookRecommTableViewCell", for: indexPath)
            cell.textLabel?.text = shownFoods[indexPath.row]
            return cell
        } else {
            let cell = ingreTableView.dequeueReusableCell(withIdentifier: "ingreTableViewCell", for: indexPath)
            cell.textLabel?.text = ingreArr[indexPath.row]
            return cell
        }
        
    }
    
    func tableView (_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if tableView == searchTableView {
            
        } else {
            ingreTableView.beginUpdates()
            ingreArr.remove(at: indexPath.row)
            ingreTableView.deleteRows(at: [indexPath], with: .fade)
            ingreTableView.endUpdates()
            print(ingreArr)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == searchTableView {
            //음식 선택 시
            let currentCell = tableView.cellForRow(at: indexPath)?.textLabel!.text
            print(currentCell ?? "")
            ingreArr.append(currentCell ?? "")
            ingreTableView.reloadData()
            tableView.isHidden = true
        
            //print(selectedIngre)
            //var currentIndex = foods.filter{$0.name==currentCell}.map{$0.id}[0]
            //print(currentIndex)
            //let inputId = SearchInput(id:currentIndex)
            //vc.search = 1
            //vc.id = SearchInput(id:currentIndex)
            //navigationController?.pushViewController(vc, animated: true)
        } else if tableView == ingreTableView {
            
        }
        
    }
    
    
}
