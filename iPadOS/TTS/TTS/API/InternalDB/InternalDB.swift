//
//  InternalDB.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/02.
//

import UIKit

protocol InternalDB {
    associatedtype DataType: Codable
    var key: String { get }
    func _save(data: DataType)
    func _get() -> DataType?
}

extension InternalDB {
    func _save(data: DataType) {
        if let encodedData = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }
    
    func _get() -> DataType? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        
        guard let decodedData = try? JSONDecoder().decode(DataType.self, from: data) else {
            return nil
        }
        return decodedData
    }
}

