//
//  ProfileDB.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/08.
//

import UIKit

class ProfileDB: InternalDB {
    typealias DataType = UserModel
    
    var key = "Profile"
    
    static let shared = ProfileDB()
    
    private init() {}
    
    func get() -> DataType {
        return _get() ?? DataType(id: -1, email: "-", is_supplier: false)
    }
    
    func save(data: DataType) {
        _save(data: data)
    }
}

