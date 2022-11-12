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
    
    var posts = BehaviorRelay<[Post]>(value: [])
    let disposeBag = DisposeBag()
    
    let fetchMoreDatas = PublishSubject<Void>()
    let refreshControlAction = PublishSubject<Void>()
    let refreshControlCompleted = PublishSubject<Void>()
    let isLoadingSpinnerAvaliable = PublishSubject<Bool>()
    private var isPaginationRequestStillResume = false
    private var isRefreshRequstStillResume = false
    
    private var pageCounter = 0
    
    init() {
        bind()
        self.fetchData(caetgory: "all", page: self.pageCounter, isRefreshControl: false)
    }
    
    func bind() {
        fetchMoreDatas.subscribe { [weak self] _ in
            guard let self = self else { return }
            //self.fetchDummyData(page: self.pageCounter, isRefreshControl: false)
            self.fetchData(caetgory: "all", page: self.pageCounter, isRefreshControl: false)
        }
        .disposed(by: disposeBag)
        
        refreshControlAction.subscribe { [weak self] _ in
            self?.refreshControlTriggered()
        }
        .disposed(by: disposeBag)
    }
    
    func fetchData(caetgory: String, page: Int, isRefreshControl: Bool) {
        if isPaginationRequestStillResume || isRefreshRequstStillResume { return }
        self.isRefreshRequstStillResume = isRefreshControl
        
        if pageCounter == -1  {
            isPaginationRequestStillResume = false
            return
        }
        
        isPaginationRequestStillResume = true
        isLoadingSpinnerAvaliable.onNext(true)
        
        if pageCounter == 0  || isRefreshControl {
            isLoadingSpinnerAvaliable.onNext(false)
        }
        
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        print("userId \(userId)")
        print("pageCounter \(pageCounter)")
        _ = BoardDataManager.getPosts(userIdx: userId, category: "all", page: pageCounter)
            .map { data -> [Post] in
                //let posts = data.postLists
                self.isLoadingSpinnerAvaliable.onNext(false)
                self.isPaginationRequestStillResume = false
                self.isRefreshRequstStillResume = false
                self.refreshControlCompleted.onNext(())
                return data
            }
            .take(1)
            .subscribe(onNext: {
                let oldDatas = self.posts.value
                self.posts.accept(oldDatas + $0)
                
                if $0.count == 0 {
                    self.pageCounter = -1
                } else {
                    self.pageCounter += 1
                }
            })
    }
    
    @objc func refreshControlTriggered() {
        isPaginationRequestStillResume = false
        pageCounter = 0
        posts.accept([])
        fetchData(caetgory: "all", page: 0, isRefreshControl: true)
    }
}