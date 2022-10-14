//
//  TTSAPI.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/08/28.
//

import Moya

enum TTSAPI {
    case queryAllTransactions
    case login(input: LoginModel)
    case userVerify
    
    case getSupplierInfo(id: Int)
    case getBuyerInfo(id: Int)
}

extension TTSAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://127.0.0.1:8000")!
    }
    
    var path: String {
        switch self {
        case .queryAllTransactions:
            return "/query/allTransactions"
            
        case .login:
            return "/account/login/"
            
        case .userVerify:
            return "/user/"
            
        case .getSupplierInfo(let id):
            return "/powerplant/\(id)"
            
        case .getBuyerInfo(let id):
            return "/buyer/\(id)"
        }
    }
    
    var method: Method {
        switch self {
        case .login:
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .login:
            return Data(TokenModel.sampleData.utf8)
        case .userVerify:
            return Data(UserModel.sampleData.utf8)
        default:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .queryAllTransactions:
            return .requestPlain
            
        case .login(let input):
            return .requestJSONEncodable(input)
            
        case .userVerify:
            return .requestPlain
            
        case .getSupplierInfo:
            return .requestPlain
            
        case .getBuyerInfo:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
            return [:]
        default:
            let token = TokenDB.shared.get().key
            if token == "" {
                return [:]
            }
            return ["Authorization":"Token \(token)"]
        }
    }
}
