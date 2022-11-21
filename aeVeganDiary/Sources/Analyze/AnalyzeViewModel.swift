//
//  AnalyzeViewModel.swift
//  aeVeganDiary
//
//  Created by 권하은 on 2022/11/18.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class AnalyzeViewModel: CommonViewModel, ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let colorInfoViewEvent: Observable<Void>
    }

    struct Output {
        var colorInfoViewHidden: Driver<Bool>
        var analysisData: Driver<AnalyzeResult>
    }
    
    var disposeBag = DisposeBag()
    
    private let colorInfoViewHidden = BehaviorRelay<Bool>(value: false)
    private let analysisData = PublishRelay<AnalyzeResult>()
    
    func transform(input: Input) -> Output {
        
        input.viewWillAppearEvent
            .subscribe(onNext: { [weak self] in
                self?.requestGetAnalysis(completion: { response in
                    switch response {
                    case .success(let response):
                        print("success")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
            })
            .disposed(by: disposeBag)
        
        return Output(colorInfoViewHidden: colorInfoViewHidden.asDriver(), analysisData: analysisData.asDriver(onErrorJustReturn: AnalyzeResult(status: 0, todayDate: nil, rcal: nil, rcarb: nil, rpro: nil, rfat: nil, ratioCarb: nil, ratioPro: nil, ratioFat: nil, totalCarb: nil, totalPro: nil, totalFat: nil, analysisDtos: nil)))
        /*input.inputMessage.bind(to: inputMessage).disposed(by: disposeBag)

        loadData()
        
        input.tapSend.subscribe(
            onNext: sendChat
        ).disposed(by: disposeBag)
        
        input.tapChatTextField.bind(to: isShowLoginAlert).disposed(by: disposeBag)
        
        return Output(replyArray: replyArray.asObservable(), outputMessage: inputMessage.asObservable(), isShowLoginAlert: isShowLoginAlert.asObservable())*/
    }
    
}

extension AnalyzeViewModel {
    private func requestGetAnalysis(completion: @escaping (Result<AnalyzeResponse, Error>) -> Void ) {
        provider.request(.getAnalysis) { result in
            self.process(type: AnalyzeResponse.self, result: result, completion: completion)
        }
        
    }
}
