//
//  BuyerInfoVM.swift
//  TTS
//
//  Created by 안현주 on 2022/09/14.
//

import RxSwift
import RxRelay

struct BuyerInfoVM: BasicVM {
    internal var disposeBag = DisposeBag()
    private let repository = TransactionRepository()
    
    struct Input {
        var id: Int
    }
    
    struct Output {
        var transactions: Observable<[TransactionModel]>
    }
    
    func transform(input: Input) -> Output {
        return Output(transactions: repository.getTransactionByBuyer(buyer: input.id).asObservable())
    }
}
