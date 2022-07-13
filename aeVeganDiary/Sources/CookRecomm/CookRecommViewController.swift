//
//  CookRecommViewController.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/07/11.
//
import SwiftUI

struct SearchView: View {
    //@StateObject var oo = CookRecommObservableObject()
    @State private var searchTerm = ""
    
    var body: some View {
        NavigationView{
            VStack {
                Text("재료를 찾아보세요")
                    .font(.title.weight(.bold))
                Text("만들 수 있는 채식음식을 추천해드립니다.")
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.gray)
            .navigationTitle("나의 냉장고")
        }
        .searchable(text: $searchTerm)
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

/*
class CookRecommViewController: BaseViewController, UITableViewDelegate {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    
    var shownFoods = [String]()
    let allFoods = ["비빔밥","비비빅","비비빅1","비비빅2","비비빅3","비비빅4","비비빅5","볶음밥"]
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "검색하기")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CookRecommTableViewCell", bundle: nil), forCellReuseIdentifier: "CookRecommTableViewCell")
        setBackButton()
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
                self.shownFoods = self.allFoods.filter { $0.hasPrefix(query) }
                self.tableView.reloadData()
    })
            //.addDisposableTo(disposeBag)
    }
}


extension CookRecommViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownFoods.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CookRecommTableViewCell", for: indexPath) as! CookRecommTableViewCell
        cell.cookRecommtvclb?.text = shownFoods[indexPath.row]
        
        return cell
    }
}

*/
