//
//  TokenDB.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/02.
//

import UIKit

class TokenDB: InternalDB {
    typealias DataType = TokenModel
    
    var key = "Token"
    
    static let shared = TokenDB()
    
    private init() {}
    
    func get() -> DataType {
        return _get() ?? TokenModel(key: "")
    }
    
    func save(data: DataType) {
        _save(data: data)
    }
}

