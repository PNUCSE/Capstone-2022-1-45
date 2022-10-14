//
//  RecListVM.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/08.
//

import RxSwift
import RxRelay

struct RecListVM: BasicVM {
    internal var disposeBag = DisposeBag()
    private let repository = RecListRepository()
    
    struct Input {
        var id: Int
    }
    
    struct Output {
        var recList: Observable<[RecModel]>
    }
    
    func transform(input: Input) -> Output {
        return Output(
            recList: repository.getCertificateBysypplier(id: input.id).asObservable()
        )
    }
}
