//
//  PostingViewModel.swift
//  aeVeganDiary
//
//  Created by 소정의 Mac on 2022/11/18.
//

import Foundation
import RxSwift
import RxCocoa

class PostingViewModel {
    static let shared = PostingViewModel()
    
    var posts = BehaviorRelay<[PostingLists]>(value: [])
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
        self.fetchData(page: self.pageCounter, isRefreshControl: false)
    }
    
    func bind() {
        fetchMoreDatas.subscribe { [weak self] _ in
            guard let self = self else {return}
            self.fetchData(page: self.pageCounter, isRefreshControl: false)
        }
        .disposed(by: disposeBag)
        
        refreshControlAction.subscribe { [weak self] _ in
            self?.refreshControlTriggered()
        }
        .disposed(by: disposeBag)
    }
    
    func fetchData(page: Int, isRefreshControl: Bool){
        if isPaginationRequestStillResume || isRefreshRequstStillResume {return}
        self.isRefreshRequstStillResume = isRefreshControl
        
        if pageCounter == -1{
            isPaginationRequestStillResume = false
            return
        }
        
        isPaginationRequestStillResume = true
        isLoadingSpinnerAvaliable.onNext(true)
        
        if pageCounter == 0 || isRefreshControl{
            isLoadingSpinnerAvaliable.onNext(false)
        }
        
        let userId = UserDefaults.standard.integer(forKey: "UserId")
        _ = PostingDataManager.getPostings(userIdx: userId, page: pageCounter)
            .map { data -> [PostingLists] in
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
    
    @objc func refreshControlTriggered(){
        isPaginationRequestStillResume = false
        pageCounter = 0
        posts.accept([])
        fetchData(page: 0, isRefreshControl: true)
    }
    
    
}
