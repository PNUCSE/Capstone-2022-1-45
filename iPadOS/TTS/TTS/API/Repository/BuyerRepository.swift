//
//  BuyerRepository.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/14.
//

import Moya
import RxSwift

class BuyerRepository: BaseRepository<TTSAPI> {
    
    func getBuyerInfo(id: Int) -> Single<BuyerInfo> {
        return getProvider(mode: .real, debug: true).rx
            .request(.getBuyerInfo(id: id))
            .map(BuyerInfo.self)
    }
}
