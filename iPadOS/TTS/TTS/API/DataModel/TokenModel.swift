//
//  TokenModel.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/02.
//

import Foundation

struct TokenModel: Codable {
    var key: String
}

extension TokenModel {
    static let sampleData =
    """
    {
        "key" : "123456789"
    }
    """
}
