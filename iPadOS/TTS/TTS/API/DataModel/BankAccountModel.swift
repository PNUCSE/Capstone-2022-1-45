//
//  BankAccountModel.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/07.
//

import Foundation

struct BankModel: Decodable {
    var name: String
}

struct BankAccountModel: Decodable {
    var bank: BankModel
    var number: String
}

extension BankAccountModel {
    func getString() -> String {
        bank.name + " " + number
    }
}
