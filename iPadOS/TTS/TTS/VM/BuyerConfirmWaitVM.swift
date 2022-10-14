//
//  BuyerConfirmWaitVM.swift
//  TTS
//
//  Created by 안현주 on 2022/09/12.
//

import RxSwift
import RxRelay

struct BuyerConfirmWaitVM: BasicVM {
    internal var disposeBag = DisposeBag()
    private let repository = TransactionRepository()
    
    struct Input {
        var id: Int
    }
    
    struct Output {
        var transactions: Observable<[TransactionModel]>
    }
    
    func transform(input: Input) -> Output {
        return Output(transactions: repository.getNotConfirmedByBuyer(buyer: input.id).asObservable())
    }
}
