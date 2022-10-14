//
//  RegisterCertificateModel.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/06.
//

import Foundation

struct RegisterCertificateModel: Encodable {
    var supplier: Int
    var quantity: Int
    var is_jeju: Bool
    var supply_date: Int
    var expire_date: Int
}
