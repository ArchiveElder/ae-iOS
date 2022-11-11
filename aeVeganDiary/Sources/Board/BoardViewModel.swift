//
//  BoardViewModel.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/09.
//

import Foundation
import RxSwift
import RxCocoa

class BoardViewModel {
    static let shared = BoardViewModel()
    
    var posts = BehaviorSubject<[Post]>(value: [])
    
    init() {
        reloadData()
    }
    
    func reloadData() {
        // Observable<Data> --> subscribe --> members
        /*_ = BoardDataManager.fetchData(url: APIManager.MEMBER_LIST_URL)
            .map { data -> [Member] in
                let members = try! JSONDecoder().decode([Member].self, from: data)
                return members
            }
            .take(1) // 버튼 누를 경우에도 호출되므로, 1번만 수행하게끔 함
            .subscribe(onNext: { self.members.onNext($0) })*/
        
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        print("userId \(userId)")
        _ = BoardDataManager.getPosts(userIdx: userId, page: 1, size: 5)
            .map { data -> [Post] in
                //let posts = data.postLists
                return data
            }
            .take(1)
            .subscribe(onNext: { self.posts.onNext($0) })
    }
}
