//
//  FabricAPI.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/06.
//

import Moya

enum FabricAPI {
    case registerCertificate(input: RegisterCertificateModel)
    case queryCertificateBySupplier(id: Int)
    
    case createTransaction(input: CreateTransactionModel)
    case executeTransaction(input: ExecuteTransactionModel)
    case approveTransaction(input: ApproveTransactionModel)
    
    case queryTransactionByID(id: Int)
    case queryAllTransactions
    case queryUnexecutedTransactions
    case queryExecutedTransactions
    case queryTransactionBySupplier(input: QueryBySupplierModel)
    case queryTransactionByBuyer(input: QueryByBuyerModel)
    case queryNotConfirmedBySupplier(input: QueryBySupplierModel)
    case queryNotConfirmedByBuyer(input: QueryByBuyerModel)
}

extension FabricAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://125.240.67.176:8080")!
    }
    
    var path: String {
        switch self {
        case .registerCertificate:
            return "/certificate/register/"
            
        case .queryCertificateBySupplier(let id):
            return "/certificate/query/\(id)"
            
            
        case .createTransaction:
            return "/transaction/create/"
            
        case .executeTransaction:
            return "/transaction/execute/"
            
        case .approveTransaction:
            return "/transaction/approve/"
            
            
            
        case .queryTransactionByID(let id):
            return "/transaction/query/\(id)"
            
        case .queryAllTransactions:
            return "/transaction/query-all/"
            
        case .queryUnexecutedTransactions:
            return "/transaction/query-nonexecuted/"
            
        case .queryExecutedTransactions:
            return "/transaction/query-executed/"
            
            
        case .queryTransactionBySupplier:
            return "/transaction/query-by-supplier/"
            
        case .queryTransactionByBuyer:
            return "/transaction/query-by-buyer/"
            
        case .queryNotConfirmedBySupplier:
            return "/transaction/query-non-confirmed-by-supplier/"
            
        case .queryNotConfirmedByBuyer:
            return "/transaction/query-non-confirmed-by-buyer/"
            
        }
    }
    
    var method: Method {
        switch self {
        case .createTransaction, .executeTransaction, .approveTransaction,
                .queryTransactionBySupplier, .queryTransactionByBuyer, .registerCertificate, .queryNotConfirmedBySupplier, .queryNotConfirmedByBuyer:
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .queryAllTransactions, .queryExecutedTransactions,
                .queryTransactionBySupplier, .queryTransactionByBuyer, .queryNotConfirmedBySupplier, .queryNotConfirmedByBuyer:
            return Data(TransactionModel.sampleData.utf8)
            
        case .queryCertificateBySupplier:
            return Data(RecModel.sampleData.utf8)
            
        default:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .registerCertificate(let input):
            return .requestJSONEncodable(input)
            
        case .queryCertificateBySupplier:
            return .requestPlain
            
            
        case .createTransaction(let input):
            return .requestJSONEncodable(input)
            
        case .executeTransaction(let input):
            return .requestJSONEncodable(input)
            
        case .approveTransaction(let input):
            return .requestJSONEncodable(input)
            
            
        case .queryTransactionByID:
            return .requestPlain
            
        case .queryAllTransactions:
            return .requestPlain
            
        case .queryUnexecutedTransactions:
            return .requestPlain
            
        case .queryExecutedTransactions:
            return .requestPlain
            
        case .queryTransactionBySupplier(let input):
            return .requestJSONEncodable(input)
            
        case .queryTransactionByBuyer(let input):
            return .requestJSONEncodable(input)
            
        case .queryNotConfirmedBySupplier(let input):
            return .requestJSONEncodable(input)
            
        case .queryNotConfirmedByBuyer(let input):
            return .requestJSONEncodable(input)
        }
    }
    
    
    var headers: [String: String]? {
        return [:]
    }
}
