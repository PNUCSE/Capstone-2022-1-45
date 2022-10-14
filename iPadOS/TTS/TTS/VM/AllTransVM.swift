//
//  AllTransVM.swift
//  TTS
//
//  Created by 안현주 on 2022/09/07.
//

import RxSwift
import RxRelay
import Foundation

struct AllTransVM {
    internal var disposeBag = DisposeBag()
    private let repository = TransactionRepository()
    
    struct Output {
        var transactions: Observable<[TransactionModel]>
    }
    
    func transform() -> Output {
        return Output(transactions: repository.getAllTransactions().asObservable())
    }
}
