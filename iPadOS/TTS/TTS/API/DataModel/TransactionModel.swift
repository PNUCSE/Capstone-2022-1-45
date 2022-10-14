//
//  TransactionModel.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/02.
//

import Foundation

struct TransactionModel: Decodable {
    struct InnerModel: Decodable {
        var id: String
        
        var target: String
        var price: Int
        var quantity: Int
        
        @IntWrapper var registeredDate: Int
        @OptionalIntWrapper var executedDate: Int?
        
        var supplier: String
        var buyer: String?
        
        @BoolWrapper var is_confirmed: Bool
    }
    var Transaction: InnerModel
}

extension TransactionModel {
    static let sampleData: String =
    """
    [
        { "Transaction": {
            "id": "TRANSACTION_2",
            "price": 123,
            "quantity": 123,
            "registeredDate": 1662967283,
            "executedDate": null,
            "target": "CERTIFICATE_23782374",
            "supplier": "2",
            "buyer": null,
            "is_confirmed": false
        }},
      
    ]
    """
}
