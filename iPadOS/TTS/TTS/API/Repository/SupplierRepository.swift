//
//  UserInfoRepository.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/07.
//

import Moya
import RxSwift

class SupplierRepository: BaseRepository<TTSAPI> {
    
    func getSupplierInfo(id: Int) -> Single<SupplierModel> {
        return getProvider(mode: .real, debug: true).rx
            .request(.getSupplierInfo(id: id))
            .map(SupplierModel.self)
    }
}
