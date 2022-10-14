//
//  RecListRepository.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/08.
//

import Moya
import RxSwift

class RecListRepository: BaseRepository<FabricAPI> {
    
    func getCertificateBysypplier(id: Int) -> Single<[RecModel]> {
        return getProvider(mode: .real, debug: true).rx
            .request(.queryCertificateBySupplier(id: id))
            .map([RecModel].self)
    }
}
