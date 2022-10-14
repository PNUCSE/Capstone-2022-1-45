//
//  CreateTransactionModel.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/07.
//

import Foundation

struct CreateTransactionModel: Encodable {
    var target: String
    var price: Int
    var quantity: Int
    var supplier: Int
}
