//
//  SupplierModel.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/07.
//

import Foundation

struct SupplierModel: Decodable {
    var id: Int
    var bank_account: BankAccountModel
    var name: String
    var registration_number: String
    var post_num: Int
    var address: String
    var phone_number: String
    var owner: Int
}
