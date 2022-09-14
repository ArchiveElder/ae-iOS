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

    @IBOutlet var ingreImageView: UIImageView!
    @IBOutlet var ingreLabel: UILabel!
    
    @IBOutlet var tabCollectionView: UICollectionView!
    @IBOutlet var recommCollectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchTableView: UITableView!
    @IBAction func recommAction(_ sender: Any) {
        if ingreArr.count == 0 {
            presentBottomAlert(message: "재료가 선택되지 않았습니다.")
        } else {
            
        }
        
    }
    @IBOutlet var recommButton: UIButton!
    @IBOutlet var ingreTableView: UITableView!
    
    
    var ingreResponse: IngreResponse?
    var ingre = [Ingre]()
    var shownFoods = [String]()
    
    
    var cookRecommResponse: CookRecommResponse?
    var cookRecomm = [CookRecomm?]()
    var searchBarFocused = false
    var ingreArr = [String]()
    var disposeBag = DisposeBag()
    
    var selected : Int? = 0
    var hasIngre : Bool = false
    
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
        
        
        //collectionView
        recommCollectionView.delegate = self
        recommCollectionView.dataSource = self
        recommCollectionView.register(UINib(nibName: "RecommCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommCollectionViewCell")
        recommCollectionView.backgroundColor = .clear
        
        
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.register(UINib(nibName: "RecommTabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommTabCollectionViewCell")
        tabCollectionView.backgroundColor = .clear
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

extension RecommCookViewController : UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    // collectionView 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tabCollectionView {
            return CGSize(width: tabCollectionView.frame.width / 3 - 1.2, height: tabCollectionView.frame.height)
        } else {
            return CGSize(width: recommCollectionView.frame.width, height: recommCollectionView.frame.height)
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabCollectionView {
            let recommList = ["추천1", "추천2", "추천3"]
            if(cookRecomm.count != 0 && cookRecomm[indexPath.row]!.food.count != 0){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommTabCollectionViewCell", for: indexPath) as! RecommTabCollectionViewCell
                //cell.tabLabel.text = recommList[indexPath.row]
                cell.tabLabel.text = cookRecomm[indexPath.row]?.food
                
                if selected == indexPath.row {
                    cell.recommTabBackgroundView.backgroundColor = .white
                } else {
                    cell.recommTabBackgroundView.backgroundColor = .lGray
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommTabCollectionViewCell", for: indexPath) as! RecommTabCollectionViewCell
                return cell
                
            }
            
        } else {
            //추천 음식 collectionView
            if(cookRecomm.count != 0 && cookRecomm[indexPath.row]!.food.count != 0){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommCollectionViewCell", for: indexPath) as! RecommCollectionViewCell
                cell.cookRecomm = cookRecomm[indexPath.row]
                cell.hasTableView.reloadData()
                cell.noTableView.reloadData()
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommCollectionViewCell", for: indexPath) as! RecommCollectionViewCell
                return cell
            }
            
        }
        
    }
    
    // 탭 collectionView의 cell들 누르면 실행되는 코드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCollectionView {
            recommCollectionView.scrollToItem(at: NSIndexPath(item: indexPath.row, section: 0) as IndexPath, at: .right, animated: false)
            selected = indexPath.row
            collectionView.reloadData()
        }
    }
    
    func getIngreData(result: IngreResponse){
        dismissIndicator()
        self.ingreResponse = result
        self.ingre = result.data
    }
    
    func getRecomm(result: CookRecommResponse){
        dismissIndicator()
        self.cookRecommResponse = result
        self.cookRecomm = result.foodDto
        self.tabCollectionView.reloadData()
        self.recommCollectionView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int = 0
        if tableView == searchTableView {
            count = shownFoods.count
        } else if tableView == ingreTableView {
            count = ingreArr.count
            if(ingreArr.count == 0 ){
                hasIngre = false
                print("재료 없음")
            } else if (ingreArr.count != 0){
                hasIngre = true
                print("재료 있음")
            }
            
            if(hasIngre == true) {
                recommButton.isHidden = false
                searchTableView.isHidden = false
                ingreImageView.isHidden = true
                ingreLabel.isHidden = true
            } else {
                recommButton.isHidden = true
                searchTableView.isHidden = true
                ingreImageView.isHidden = false
                ingreLabel.isHidden = false
            }
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
            //CookRecommDataManager().requestData(ingreInput, viewController: self)
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
