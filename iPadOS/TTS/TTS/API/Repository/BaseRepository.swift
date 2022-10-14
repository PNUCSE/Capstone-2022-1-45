//
//  BaseRepository.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/08/28.
//

import Moya
import RxSwift

enum APIEnvironment {
    case test, real
}

class BaseRepository<API: TargetType> {
    
    private let realProviderWithDebug = MoyaProvider<API>(plugins: [MoyaInterceptor()])
    private let realProviderWithoutDebug = MoyaProvider<API>()
    private let testProviderWithDebug: MoyaProvider<API>
    private let testProviderWithoutDebug: MoyaProvider<API>
    
    init() {
        let customEndpointClosure = { (target: API) -> Endpoint in
            return Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { .networkResponse(200, target.sampleData)},
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers)
        }
        
        testProviderWithDebug =  MoyaProvider<API> (
            endpointClosure: customEndpointClosure,
            stubClosure: MoyaProvider.delayedStub(0),
            plugins: [MoyaInterceptor()])
        
        testProviderWithoutDebug =  MoyaProvider<API> (
            endpointClosure: customEndpointClosure,
            stubClosure: MoyaProvider.delayedStub(0))
    }
    
    func getProvider(mode: APIEnvironment, debug: Bool) -> MoyaProvider<API> {
        switch mode {
        case .test:
            return getTestProvider(debug)
        case .real:
            return getRealProvider(debug)
        }
    }
    
    private func getRealProvider(_ debug: Bool) -> MoyaProvider<API> {
        if debug { return realProviderWithDebug }
        
        return realProviderWithoutDebug
    }
    
    private func getTestProvider(_ debug: Bool) -> MoyaProvider<API> {
        if debug { return testProviderWithDebug }
        
        return testProviderWithoutDebug
    }
}
