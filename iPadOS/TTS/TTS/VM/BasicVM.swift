//
//  BasicVM.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/03.
//

import RxSwift

protocol BasicVM {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
