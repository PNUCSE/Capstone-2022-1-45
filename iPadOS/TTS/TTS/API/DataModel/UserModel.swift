//
//  UserModel.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/12.
//

import Foundation

struct UserModel: Codable {
    var id: Int
    var email: String
    var is_supplier: Bool
}

extension UserModel {
    static let sampleData: String =
    """
    {
        "id": 1,
        "email": "admin@admin.com",
        "is_supplier": true
    }
    """
}
