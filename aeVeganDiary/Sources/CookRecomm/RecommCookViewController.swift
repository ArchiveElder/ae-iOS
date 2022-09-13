//
//  RecommCookViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/09/13.
//

import UIKit
import RxCocoa
import RxSwift
import SafariServices

class RecommCookViewController: BaseViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchTableView: UITableView!
    @IBAction func RecommAction(_ sender: Any) {
        if ingreArr.count == 0 {
            presentBottomAlert(message: "재료가 선택되지 않았습니다.")
        } else {
            
        }
        
    }
    @IBOutlet var RecommButton: UIButton!
    @IBOutlet var ingreTableView: UITableView!
    
    
    var ingreResponse: IngreResponse?
    var ingre = [Ingre]()
    var shownFoods = [String]()
    
    
    var cookRecommResponse: CookRecommResponse?
    var cookRecomm = [CookRecomm?]()
    var searchBarFocused = false
    var ingreArr = [String]()
    var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showIndicator()
        IngreDataManager().getIngreData(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Ingre Search
        searchBar.delegate = self
        searchTableView.isHidden = true
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(UINib(nibName: "CookRecommTableViewCell", bundle: nil), forCellReuseIdentifier: "CookRecommTableViewCell")
        setup()
        
        //Ingre Select
        ingreTableView.dataSource = self
        ingreTableView.delegate = self
        ingreTableView.register(UINib(nibName: "ingreTableViewCell", bundle: nil), forCellReuseIdentifier: "ingreTableViewCell")
        
        
        
    }

    //MARK: 검색 tableView func
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
    }
    
    //MARK: SearchTable Visible 관련 func
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            searchTableView.isHidden = true
            dismissKeyboardWhenTappedAround()
        } else {
            searchTableView.isHidden = false
            if let recognizers = self.view.gestureRecognizers {
                for recognizer in recognizers {
                    self.view.removeGestureRecognizer(recognizer)
                }
            }
        }
    }
}

extension RecommCookViewController : UITableViewDataSource, UITableViewDelegate{
    
    func getIngreData(result: IngreResponse){
        dismissIndicator()
        self.ingreResponse = result
        self.ingre = result.data
    }
    
    func getRecomm(result: CookRecommResponse){
        dismissIndicator()
        self.cookRecommResponse = result
        self.cookRecomm = result.foodDto
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "CookRecommTableViewCell", for: indexPath)
        cell.textLabel?.text = shownFoods[indexPath.row]
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        return cell
    }
    
    func tableView (_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if tableView == searchTableView {
            
        } else {
            ingreTableView.beginUpdates()
            ingreArr.remove(at: indexPath.row)
            ingreTableView.deleteRows(at: [indexPath], with: .fade)
            ingreTableView.endUpdates()
            var ingreInput = IngreInput(ingredients: ingreArr)
            CookRecommDataManager().requestData(ingreInput, viewController: self)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchTableView {
            //음식 선택 시
            searchBar.text = ""
            let currentCell = tableView.cellForRow(at: indexPath)?.textLabel!.text
            ingreArr.append(currentCell ?? "")
            var ingreInput = IngreInput(ingredients: ingreArr)
            CookRecommDataManager().requestData(ingreInput, viewController: self)
            ingreTableView.reloadData()
            tableView.isHidden = true
            dismissKeyboard()
        } else if tableView == ingreTableView {
            
        }
    }
    
}
//옆에 사람들이 천주교를 믿는게 아니라 천주교를 믿는 자신에게 흠뻑 빠져있다고 얘기했는데
//ㅅㅔ례명이 가지고 싶어서 천주교를 믿고싶던 과거의 내가 생각낫어
