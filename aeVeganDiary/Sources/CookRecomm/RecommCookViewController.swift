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

class RecommCookViewController: BaseViewController, UISearchBarDelegate, UIWebViewDelegate, RecommCollectionViewCellDelegate {
    
    lazy var ingreSelectedArr: [Int] = []
    lazy var ingreDataManager: IngreDataManagerDelegate = IngreDataManager()
    
    @IBOutlet var ingreImageView: UIImageView!
    @IBOutlet var ingreLabel: UILabel!
    
    @IBOutlet var tabCollectionView: UICollectionView!
    @IBOutlet var recommCollectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchTableView: UITableView!
    
    @IBAction func recommAction(_ sender: Any) {
        tabCollectionView.isHidden = false
        recommCollectionView.isHidden = false
        selected = 0
        let indexPath = IndexPath(item: 0, section: 0)
        recommCollectionView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: false)
        self.tabCollectionView.reloadData()
        self.recommCollectionView.reloadData()
    }
    
    @IBOutlet var recommButton: UIButton!
    @IBOutlet var ingreTableView: UITableView!
    
    //RecommCollectionViewCellDelegate URL 전달
    func recipeButton(cell: RecommCollectionViewCell) {
        safari(myUrl: myUrl)
    }
    var myUrl: NSURL = NSURL(string: "www.naver.com")!
    
    var ingreResponse: IngreResponse?
    var ingre = [Ingre]()
    var shownFoods = [String]()
    
    var cookRecommResponse: CookRecommResponse?
    var cookRecomm = [CookRecomm?]()
    var searchBarFocused = false
    var ingreArr = [String]()
    var recommIngreArr = [String]()
    var disposeBag = DisposeBag()
    
    var selected : Int? = 0
    var hasIngre : Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showIndicator()
        ingreDataManager.getIngreData(delegate: self)
    }
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //dismissKeyboardWhenTappedAround()
        setNavigationTitle(title: "채식 요리 추천")
        //setResetButton()
        self.searchTableView.keyboardDismissMode = .onDrag
        
        ingreArr = UserDefaults.standard.array(forKey: "UserIngre") as! [String]
        ingreSelectedArr = Array<Int>(repeating: 0, count: ingreArr.count)
        print(ingreSelectedArr)
        
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
        ingreTableView.register(UINib(nibName: "IngreTableViewCell", bundle: nil), forCellReuseIdentifier: "IngreTableViewCell")
        
        //collectionView
        recommCollectionView.delegate = self
        recommCollectionView.dataSource = self
        recommCollectionView.register(UINib(nibName: "RecommCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommCollectionViewCell")
        recommCollectionView.backgroundColor = .clear
        
        
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.register(UINib(nibName: "RecommTabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecommTabCollectionViewCell")
        tabCollectionView.backgroundColor = .clear
        
        if ingreArr.count == 0 {
            tabCollectionView.isHidden = true
            recommCollectionView.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            if isKeyboardShowing {
                dismissKeyboardWhenTappedAround()
            } else {
                if let recognizers = self.view.gestureRecognizers {
                    for recognizer in recognizers {
                        self.view.removeGestureRecognizer(recognizer)
                    }
                }
            }
        }
    }
    
    
    func setResetButton() {
        let resetButton = UIBarButtonItem(image: UIImage(named:"reset"), style: .plain, target: self, action: #selector(reset))
        resetButton.tintColor = .darkGreen
        self.navigationItem.setRightBarButton(resetButton, animated: false)
    }
    
    @objc func reset() {
        self.ingreArr.removeAll()
        ingreTableView.reloadData()
    }
    
    //MARK: WebView func
    func safari (myUrl : NSURL) {
        print(myUrl)
        let safariView : SFSafariViewController = SFSafariViewController(url: myUrl as! URL)
        present(safariView, animated: true, completion: nil)
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
                    $0.name.localizedCaseInsensitiveContains(query) }.map {$0.name}
                    .sorted { ($0.hasPrefix(query) ? 0 : 1) < ($1.hasPrefix(query) ? 0 : 1)}
                self.searchTableView.reloadData()
            })
    }
    
    //최초 SearchBar 클릭 시
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchTableView.dataSource = self
        //searchTableView.allowsSelection = true
        searchBar.setShowsCancelButton(true, animated:true)
        var searchTerm = searchBar.text
        if(searchTerm!.isEmpty == true){
            searchTableView.isHidden = false
            self.shownFoods = self.ingre.map{$0.name}
            self.searchTableView.reloadData()
            //dismissKeyboardWhenTappedAround()
        }
    }
    
    //SearchBar Text 변경 이벤트
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText==""){
            self.shownFoods = self.ingre.map{$0.name}
            self.searchTableView.reloadData()
            searchTableView.isHidden = false
            //dismissKeyboardWhenTappedAround()
        } else {
            searchTableView.isHidden = false
            /*if let recognizers = self.view.gestureRecognizers {
                for recognizer in recognizers {
                    self.view.removeGestureRecognizer(recognizer)
                }
            }*/
            searchBar
                .rx.text
                .orEmpty
                .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .filter{ !$0.isEmpty }
                .subscribe(onNext: { [unowned self] query in
                    self.shownFoods = self.ingre.filter {
                        $0.name.localizedCaseInsensitiveContains(query) }.map {$0.name}
                        .sorted { ($0.hasPrefix(query) ? 0 : 1) < ($1.hasPrefix(query) ? 0 : 1)}
                    self.searchTableView.reloadData()
                })
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true);
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.searchTableView.isHidden = true
        dismissKeyboard()
    }
    
    
}

//MARK: 서버 통신 extension
extension RecommCookViewController : IngreViewDelegate{
    
    func didRetrieveIngreData(_ result: IngreResponse) {
        dismissIndicator()
        self.ingreResponse = result
        self.ingre = result.result!.data
    }
    
    func failedToRequest(message: String, code: Int) {
        dismissIndicator()
        presentAlert(message: message)
        if code == 403 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.changeRootViewController(LoginViewController())
            }
        }
    }}
    
  
extension RecommCookViewController : UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, IngreTableviewCellDelegate{
    
    //MARK: Delegate extensions
    func didTapIngreDeleteButton(with ingreLabel: String) {
        if(ingreArr.firstIndex(of: ingreLabel) != nil){
            if let index = ingreArr.firstIndex(of: ingreLabel) {
                ingreArr.remove(at: index)
                ingreSelectedArr.remove(at: index)
                print(ingreSelectedArr)
                if(recommIngreArr.firstIndex(of: ingreLabel) != nil){
                    if let index = recommIngreArr.firstIndex(of: ingreLabel) {
                        recommIngreArr.remove(at: index)
                    }
                }
            }
            var ingreInput = IngreInput(ingredients: recommIngreArr)
            print(ingreInput)
            CookRecommDataManager().postRcommCook(ingreInput, viewController: self)
            UserDefaults.standard.set(ingreArr, forKey: "UserIngre")
            ingreTableView.reloadData()
        }
    }
    
    
    func didTapIngreCheckButton(with ingreLabel: String, with ingreSelected: Bool) {
        if(ingreSelected == true){
            if(recommIngreArr.firstIndex(of: ingreLabel) == nil){
                recommIngreArr.append(ingreLabel)
                if let index = ingreArr.firstIndex(of: ingreLabel) {
                    ingreSelectedArr[index]=1
                    print(ingreSelectedArr)
                }
            }
        } else {
            if(recommIngreArr.firstIndex(of: ingreLabel) != nil){
                if let index = recommIngreArr.firstIndex(of: ingreLabel) {
                    recommIngreArr.remove(at: index)
                    if let index = ingreArr.firstIndex(of: ingreLabel) {
                        ingreSelectedArr[index]=0
                        print(ingreSelectedArr)
                    }
                }
            }
        }
        if(recommIngreArr.count != 0){
            recommButton.isHidden = false
        } else {
            recommButton.isHidden = true
        }
        var ingreInput = IngreInput(ingredients: recommIngreArr)
        print(ingreInput)
        CookRecommDataManager().postRcommCook(ingreInput, viewController: self)
    }
    
    func getRecomm(result: CookRecommResponse){
            dismissIndicator()
            self.cookRecommResponse = result
            self.cookRecomm = result.foodDto
        }
      
    //MARK: 컬렉션뷰 extentions
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
                if(cookRecomm.count != 0 && cookRecomm[indexPath.row]!.food.count != 0){
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommTabCollectionViewCell", for: indexPath) as! RecommTabCollectionViewCell
                    cell.tabLabel.text = cookRecomm[indexPath.row]?.food
                    
                    if(cookRecomm[indexPath.row]!.has.count == 0){
                        cell.tabLabel.text = ""
                    }
                    
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
                    //cell.innerUrl = cookRecomm[indexPath.row]?.recipeUrl ?? ""
                    //cell.delegate = self
                    cell.recipeButton.addTarget(self, action: #selector(toSafari), for: .touchUpInside)
                    
                    if(cookRecomm[indexPath.row]!.has.count == 0){
                        cell.hasTableView.isHidden = true
                        cell.noTableView.isHidden = true
                        cell.recipeButton.isHidden = true
                        cell.sadLabel.isHidden = false
                        cell.sadImageView.isHidden = false
                        cell.noLabel.isHidden = true
                        cell.noLineView.isHidden = true
                        cell.hasLabel.isHidden = true
                        cell.hasLineView.isHidden = true
                    } else {
                        cell.hasTableView.isHidden = false
                        cell.noTableView.isHidden = false
                        cell.recipeButton.isHidden = false
                        cell.sadLabel.isHidden = true
                        cell.sadImageView.isHidden = true
                        cell.noLabel.isHidden = false
                        cell.noLineView.isHidden = false
                        cell.hasLabel.isHidden = false
                        cell.hasLineView.isHidden = false
                    }
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommCollectionViewCell", for: indexPath) as! RecommCollectionViewCell
                    cell.delegate = self
                    return cell
                }
                
            }
            
        }
        
    @objc func toSafari() {
            let url = URL(string: cookRecomm[selected ?? 0]?.recipeUrl ?? "")!
            let safariView : SFSafariViewController = SFSafariViewController(url: url)
            present(safariView, animated: true, completion: nil)
        }
        
    // 탭 collectionView의 cell들 누르면 실행되는 코드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView == tabCollectionView {
                selected = indexPath.row
                recommCollectionView.scrollToItem(at: NSIndexPath(item: selected!, section: 0) as IndexPath, at: .right, animated: false)
                collectionView.reloadData()
                recommCollectionView.reloadData()
            }
        }
        
      //MARK: 테이블뷰 extensions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            var count : Int = 0
            if tableView == searchTableView {
                count = shownFoods.count
            } else if tableView == ingreTableView {
                count = ingreArr.count
                if(ingreArr.count == 0 ){
                    hasIngre = false
                } else if (ingreArr.count != 0){
                    hasIngre = true
                }
                if(hasIngre == true) {
                    recommButton.isHidden = false
                    ingreImageView.isHidden = true
                    ingreLabel.isHidden = true
                    if(recommIngreArr.count==0){
                        recommButton.isHidden = true
                        ingreImageView.isHidden = true
                        ingreLabel.isHidden = true
                        recommCollectionView.isHidden = true
                        tabCollectionView.isHidden = true
                    } else if(recommIngreArr.count != 0){
                        ingreImageView.isHidden = true
                        ingreLabel.isHidden = true
                        recommButton.isHidden = false
                        recommCollectionView.isHidden = true
                        tabCollectionView.isHidden = true
                    }
                }
                //냉장고에 재료 없을 때
                else {
                    recommButton.isHidden = true
                    ingreImageView.isHidden = false
                    ingreLabel.isHidden = false
                    recommCollectionView.isHidden = true
                    tabCollectionView.isHidden = true
                }
                
            }
            return count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if tableView == searchTableView {
                let cell = searchTableView.dequeueReusableCell(withIdentifier: "CookRecommTableViewCell", for: indexPath)
                cell.textLabel?.text = shownFoods[indexPath.row]
                return cell
            } else {
                let cell = ingreTableView.dequeueReusableCell(withIdentifier: "IngreTableViewCell", for: indexPath) as! IngreTableViewCell
                cell.ingreLabel?.text = ingreArr[indexPath.row]
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell.selectionStyle = .none
                if(ingreSelectedArr[indexPath.row]==1){
                    cell.ingreCheckButton.isSelected = true
                } else {
                    cell.ingreCheckButton.isSelected = false
                }
                
                cell.delegate = self
                return cell
            }
            
        }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if tableView == searchTableView {
                //음식 선택 시
                searchBar.text = ""
                let currentCell = tableView.cellForRow(at: indexPath)?.textLabel!.text
                print(currentCell)
                if(ingreArr.firstIndex(of: currentCell!) == nil) {
                    ingreArr.append(currentCell ?? "")
                    UserDefaults.standard.set(ingreArr, forKey: "UserIngre")
                    ingreSelectedArr.append(0)
                    print(ingreSelectedArr)
                } else {
                    presentAlert(message: "재료가 이미 있습니다.")
                }
                //var ingreInput = IngreInput(ingredients: ingreArr)
                //CookRecommDataManager().postRcommCook(ingreInput, viewController: self)
                ingreTableView.reloadData()
                tableView.isHidden = true
                dismissKeyboard()
                searchBar.setShowsCancelButton(false, animated: true)
            } else if tableView == ingreTableView {

            }
        }
        
    }

