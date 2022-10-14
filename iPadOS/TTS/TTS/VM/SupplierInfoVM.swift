//
//  TransactionViewModel.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/06.
//

import RxSwift
import RxRelay

struct SupplierInfoVM: BasicVM {
    internal var disposeBag = DisposeBag()
    private let repository = TransactionRepository()
    
    struct Input {
        var id: Int
    }
    
    struct Output {
        var transactions: Observable<[TransactionModel]>
    }
    
    func transform(input: Input) -> Output {
        return Output(transactions: repository.getTransactionBySupplier(supplier: input.id).asObservable())
    }
}

