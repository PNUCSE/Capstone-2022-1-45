//
//  HomeVM.swift
//  TTS
//
//  Created by 안현주 on 2022/09/11.
//

import RxSwift
import RxRelay

struct HomeVM: BasicVM {
    internal var disposeBag = DisposeBag()
    private let transactionRepo = TransactionRepository()
    
    let data = PublishRelay<ChartModel>()
    
    struct Input {
        let isHourlyTapped: Observable<UITapGestureRecognizer>
        let isDailyTapped: Observable<UITapGestureRecognizer>
        let isMonthlyTapped: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        var transactions: Observable<[TransactionModel]>
        var chartData: Observable<ChartModel>
    }
    
    func transform(input: Input) -> Output {
        
        input.isHourlyTapped
            .subscribe { _ in
                getData(type: .hour)
            }.disposed(by: disposeBag)
        
        input.isDailyTapped
            .subscribe { _ in
                getData(type: .day)
            }.disposed(by: disposeBag)
        
        input.isMonthlyTapped
            .subscribe { _ in
                getData(type: .month)
            }.disposed(by: disposeBag)
        
        return Output(
            transactions: transactionRepo.getAllTransactions().asObservable(),
            chartData: data.asObservable()
        )
    }
    
    func getData(type: ChartType) {
        transactionRepo.getExecutedTransaction()
            .subscribe(onSuccess: { transactions in
                switch type {
                case .hour:
                    self.data.accept(ChartConverter.getHourly(input: transactions))
                case .day:
                    self.data.accept(ChartConverter.getDaily(input: transactions))
                case .month:
                    self.data.accept(ChartConverter.getMonthly(input: transactions))
                }
            }).disposed(by: disposeBag)
    }
}
