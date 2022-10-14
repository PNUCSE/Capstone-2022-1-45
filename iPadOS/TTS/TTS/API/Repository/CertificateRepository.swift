//
//  CertificateRepository.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/06.
//

import Moya
import RxSwift

class CertificateRepository: BaseRepository<FabricAPI> {
    
    func registerCertificate(input: RegisterCertificateModel) -> Single<Response> {
        return getProvider(mode: .real, debug: true).rx
            .request(.registerCertificate(input: input))
    }
}
