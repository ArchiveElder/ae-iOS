//
//  CookRecommViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/11.
//

import UIKit
import RxCocoa
import RxSwift
import SafariServices

class CookRecommViewController: BaseViewController, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var ingreTableView: UITableView!
    @IBOutlet var recommButton: UIButton!
    
    //@IBOutlet var recommView: UIView!
    @IBOutlet var recommTextLabel: UILabel!
    @IBOutlet var recommScrollView: UIScrollView!
    @IBOutlet var recommPageControl: UIPageControl!
    @IBOutlet weak var recommInnerView : RecommInnerView!
    
    var test: [String] = ["One", "Two", "Three"]
    var test2: [String] = ["One", "Two", "Three", "four"]
    
    //음식 찾기 API 이벤트
    @IBAction func recommResult(_ sender: Any) {
        //추천 음식 api 연결 된 상태
        
        addContentScrollView()
        setPageControl()
        recommPageControl.isHidden = false
        recommTextLabel.isHidden = false
        
        /*
         let vc = LargeCategoryViewController()
         navigationController?.pushViewController(vc, animated: true)
         */
        
    }
    
    var searchBarFocused = false
    var ingreArr = [String]()
    
    //MARK: 서버 통신 변수 선언
    var ingreResponse: IngreResponse?
    var ingre = [Ingre]()
    var cookRecommResponse: CookRecommResponse?
    var cookRecomm = [CookRecomm?]()
    
    var shownFoods = [String]()
    var disposeBag = DisposeBag()
    var allFoodsDic : Dictionary = [Int:String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        recommPageControl.isHidden = true
        recommTextLabel.isHidden = true
        //addContentScrollView()
        //setPageControl()
        
        searchBar.delegate = self
        recommScrollView.delegate = self
        
        /*
        recommInnerView?.hasDelegate = self
        recommInnerView?.hasDataSource = self
        recommInnerView?.hasRegisterClass(cellClass: hasTableViewCell.self, forCellReuseIdentifier: "hasTableViewCell")
        
        recommInnerView?.noDelegate = self
        recommInnerView?.noDataSource = self
        recommInnerView?.noRegisterClass(cellClass: hasTableViewCell.self, forCellReuseIdentifier: "noTableViewCell")
        */
        
        searchTableView.isHidden = true
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(UINib(nibName: "CookRecommTableViewCell", bundle: nil), forCellReuseIdentifier: "CookRecommTableViewCell")
        
        ingreTableView.dataSource = self
        ingreTableView.delegate = self
        ingreTableView.register(UINib(nibName: "ingreTableViewCell", bundle: nil), forCellReuseIdentifier: "ingreTableViewCell")
        
        setDismissButton()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showIndicator()
        IngreDataManager().getIngreData(viewController: self)
    }
    
    
    //MARK: 추천된 음식 CustomView 추가 func
    func addCustomView() -> RecommInnerView {
        var returnView = RecommInnerView()
        if let customView = Bundle.main.loadNibNamed("RecommInnerView", owner: nil, options: nil)?.first as? RecommInnerView {
                customView.frame = self.view.bounds
            returnView = customView
            }
        return returnView
    }
    
    func safari (myUrl : NSURL) {
        let safariView : SFSafariViewController = SFSafariViewController(url: myUrl as! URL)
        present(safariView, animated: true)
        print(myUrl)
    }
    
    //MARK: 가로 스크롤 뷰 구현 func1
    private func addContentScrollView() {
        for i in 0...2 {
            //i번째 커스텀뷰 생성
            var customView = addCustomView()
        
            //
            customView.innerUrl = cookRecomm[i]?.recipeUrl ?? ""
            customView.vc = self
            
            //i번째 추천된 음식이름 받아오기
        
            customView.recommLabel.setTitle(cookRecomm[i]!.food, for: .normal)
            var hasString : String = ""
            if cookRecomm[i]!.has.count > 0 {
                for j in 0...cookRecomm[i]!.has.count-1 {
                    hasString = hasString+"  "
                    hasString = hasString+String(cookRecomm[i]?.has[j] ?? "" )
                    hasString = hasString+"\n"
                }
            }
            
            
            
            var noString : String = ""
            for k in 0...cookRecomm[i]!.no.count-1 {
                noString = noString+"  "
                noString = noString+String(cookRecomm[i]?.no[k] ?? "" )
                noString = noString+"\n"
            }
            
            
            customView.hasLabel?.text = hasString
            customView.noLabel?.text = noString
             
            customView.hasTableView.dataSource = self
            customView.hasTableView.delegate = self
            customView.hasTableView.register(UINib(nibName: "hasTableViewCell", bundle: nil), forCellReuseIdentifier: "hasTableViewCell")
            
            
            func tableView(tableView: UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
                let cell = customView.hasTableView.dequeueReusableCell(withIdentifier: "hasTableViewCell", for: indexPath)
                cell.textLabel?.text = test[indexPath.row]
                return cell
            }
            
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return test.count
            }
            
            
            //scrollView에 i번째 customView 부착
            let xPosition = recommScrollView.frame.width * CGFloat(i)
            customView.frame = CGRect(x: xPosition, y: 0,
                 width: recommScrollView.frame.width,
                 height: recommScrollView.frame.height-30)
            
            recommScrollView.contentSize.width = customView.frame.width * CGFloat(i+1)
            recommScrollView.addSubview(customView)
        }
    }
    
    
    
    private func setPageControl(){
        recommPageControl.numberOfPages = 3
    }
    
    private func setPageControlSelectedPage(currentPage:Int){
        recommPageControl.currentPage = currentPage
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = recommScrollView.contentOffset.x/recommScrollView.frame.size.width
        setPageControlSelectedPage(currentPage: Int(round(value)))
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
        //.addDisposableTo(disposeBag)
    }
    
    //MARK: SearchTable Visible 관련 func
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
            var ingreInput = IngreInput(ingredients: ingreArr)
            CookRecommDataManager().requestData(ingreInput, viewController: self)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == searchTableView {
            //음식 선택 시
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


//MARK: 추천된 음식 Custom View Class
@IBDesignable
class RecommInnerView : UIView, UIWebViewDelegate {
    
    var vc : CookRecommViewController!
    var innerUrl :String = "https://www.naver.com/"
    
    @IBOutlet var noLabel: UILabel!
    @IBOutlet var hasLabel: UILabel!
    @IBOutlet weak var noTableView: UITableView!
    @IBOutlet weak var hasTableView: UITableView!
    @IBOutlet weak var recommLabel: UIButton!
    @IBAction func recommWebButton(_ sender: Any) {
        let myUrl = NSURL(string: innerUrl)
        vc?.safari(myUrl: myUrl!)
    }

    

    override init(frame:CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBOutlet weak var hasDelegate : UITableViewDelegate? {
        get{
            return hasTableView.delegate
        }
        set{
            hasTableView.delegate = newValue
        }
    }
    
    @IBOutlet weak var hasDataSource : UITableViewDataSource?{
        get{
            return hasTableView.dataSource
        }
        set{
            hasTableView.dataSource = newValue
        }
    }
    
    func hasRegisterClass(cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        hasTableView.register(cellClass, forCellReuseIdentifier: identifier)
        }

    func hasDequeueReusableCellWithIdentifier(identifier: String) -> UITableViewCell? {
        return hasTableView.dequeueReusableCell(withIdentifier: identifier)
        }
    
    
    @IBOutlet weak var noDelegate : UITableViewDelegate? {
        get{
            return noTableView.delegate
        }
        set{
            noTableView.delegate = newValue
        }
    }
    
    @IBOutlet weak var noDataSource : UITableViewDataSource?{
        get{
            return noTableView.dataSource
        }
        set{
            noTableView.dataSource = newValue
        }
    }
    
    func noRegisterClass(cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        noTableView.register(cellClass, forCellReuseIdentifier: identifier)
        }

    func noDequeueReusableCellWithIdentifier(identifier: String) -> UITableViewCell? {
        return noTableView.dequeueReusableCell(withIdentifier: identifier)
        }
    
}


/*
extension RecommInnerView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int = 0
        if tableView == hasTableView {
            count = test.count
            print("웅",test.count)
        } else if tableView == noTableView {
            count = test.count
        }
        return count
    }
    
    //셀 하나하나에 검색 목록 띄워줌
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == hasTableView {
            print("아아아ㅏㄱ")
            let cell = tableView.dequeueReusableCell(withIdentifier: "hasTableViewCell", for: indexPath)
            cell.textLabel?.text = test[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noTableViewCell", for: indexPath)
            cell.textLabel?.text = test[indexPath.row]
            return cell
        }
    }
    
    func tableView (_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if tableView == hasTableView {
            
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == hasTableView {
            //음식 선택 시
        } else if tableView == noTableView {
            
        }

    }
}

*/
