//
//  TransactionRepository.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/02.
//

import Moya
import RxSwift

class TransactionRepository: BaseRepository<FabricAPI> {
    
    func getAllTransactions() -> Single<[TransactionModel]> {
        return getProvider(mode: .real, debug: false).rx
            .request(.queryAllTransactions)
            .map([TransactionModel].self)
    }
    
    func createTransaction(input: CreateTransactionModel) -> Single<Response> {
        return getProvider(mode: .real, debug: true).rx
            .request(.createTransaction(input: input))
    }
    
    func executeTransaction(input: ExecuteTransactionModel) -> Single<Response> {
        return getProvider(mode: .real, debug: true).rx
            .request(.executeTransaction(input: input))
    }
    
    func approveTransaction(input: ApproveTransactionModel) -> Single<Response> {
        return getProvider(mode: .real, debug: true).rx
            .request(.approveTransaction(input: input))
    }
    
    func getPriceAvgMaxMin() -> Single<[Int]> {
        return getProvider(mode: .real, debug: true).rx
            .request(.queryExecutedTransactions)
            .map([TransactionModel].self)
            .map { txs in
                let sum = txs.reduce(0) { partialResult, tx in
                    partialResult + tx.Transaction.price
                }
                let avg = txs.count > 0 ? (Double(sum) / Double(txs.count)) : 0
                let maxVal = txs.max { tx1, tx2 in
                    tx1.Transaction.price > tx2.Transaction.price
                }?.Transaction.price
                let minVal = txs.max { tx1, tx2 in
                    tx1.Transaction.price < tx2.Transaction.price
                }?.Transaction.price
                return [Int(avg), maxVal ?? 0, minVal ?? 0]
            }
    }
    
    func getExecutedTransaction() -> Single<[TransactionModel]> {
        return getProvider(mode: .real, debug: true).rx
            .request(.queryExecutedTransactions)
            .map([TransactionModel].self)
    }
    
    func getUnexecutedTransaction() -> Single<[TransactionModel]> {
        return getProvider(mode: .real, debug: true).rx
            .request(.queryUnexecutedTransactions)
            .map([TransactionModel].self)
    }
    
    func getTransactionBySupplier(supplier: Int) -> Single<[TransactionModel]> {
        return getProvider(mode: .real, debug: true).rx
            .request(.queryTransactionBySupplier(input: QueryBySupplierModel(supplier: supplier)))
            .map([TransactionModel].self)
    }
    
    func getTransactionByBuyer(buyer: Int) -> Single<[TransactionModel]> {
        return getProvider(mode: .real, debug: true).rx
            .request(.queryTransactionByBuyer(input: QueryByBuyerModel(buyer: buyer)))
            .map([TransactionModel].self)
    }

    
    func getNotConfirmedBySupplier(supplier: Int) -> Single<[TransactionModel]> {
        return getProvider(mode: .real, debug: true).rx
            .request(.queryNotConfirmedBySupplier(input: QueryBySupplierModel(supplier: supplier)))
            .map([TransactionModel].self)
    }
    
    func getNotConfirmedByBuyer(buyer: Int) -> Single<[TransactionModel]> {
        return getProvider(mode: .real, debug: true).rx
            .request(.queryNotConfirmedByBuyer(input: QueryByBuyerModel(buyer: buyer)))
            .map([TransactionModel].self)
    }
}

