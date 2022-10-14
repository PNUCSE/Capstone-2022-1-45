//
//  LoginRepository.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/02.
//

import Moya
import RxSwift

class LoginRepository: BaseRepository<TTSAPI> {
    
    func login(input: LoginModel) -> Single<TokenModel> {
        return getProvider(mode: .real, debug: true).rx
            .request(.login(input: input))
            .map(TokenModel.self)
    }
    
    func verifyUser() -> Single<UserModel> {
        return getProvider(mode: .real, debug: true).rx
            .request(.userVerify)
            .map(UserModel.self)
    }
    
}
