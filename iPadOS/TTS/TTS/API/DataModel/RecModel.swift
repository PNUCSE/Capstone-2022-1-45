//
//  RECModel.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/08.
//

import Foundation

struct RecModel: Decodable {
    struct InnerModel: Decodable {
        var id: String
        var supplier: String
        var quantity: Int
        var is_jeju: Bool
        var supply_date: Int
        var expire_date: Int
    }
    var Certificate: InnerModel
}

extension RecModel {
    static let sampleData: String =
    """
    [
        {"Certificate": {
            "id": "CERTIFICATE_123",
            "supplier": "1",
            "quantity": 100,
            "is_jeju": true,
            "supply_date": 2736262,
            "expire_date": 3838243
        }},
        {"Certificate": {
            "id": "CERTIFICATE_456",
            "supplier": "1",
            "quantity": 100,
            "is_jeju": false,
            "supply_date": 2736262,
            "expire_date": 3838243
        }},
        {"Certificate": {
            "id": "CERTIFICATE_123",
            "supplier": "1",
            "quantity": 100,
            "is_jeju": true,
            "supply_date": 2736262,
            "expire_date": 3838243
        }},
        {"Certificate": {
            "id": "CERTIFICATE_456",
            "supplier": "1",
            "quantity": 100,
            "is_jeju": false,
            "supply_date": 2736262,
            "expire_date": 3838243
        }},
        {"Certificate": {
            "id": "CERTIFICATE_123",
            "supplier": "1",
            "quantity": 100,
            "is_jeju": true,
            "supply_date": 2736262,
            "expire_date": 3838243
        }},
        {"Certificate": {
            "id": "CERTIFICATE_456",
            "supplier": "1",
            "quantity": 100,
            "is_jeju": false,
            "supply_date": 2736262,
            "expire_date": 3838243
        }},
        {"Certificate": {
            "id": "CERTIFICATE_123",
            "supplier": "1",
            "quantity": 100,
            "is_jeju": true,
            "supply_date": 2736262,
            "expire_date": 3838243
        }},
        {"Certificate": {
            "id": "CERTIFICATE_456",
            "supplier": "1",
            "quantity": 100,
            "is_jeju": false,
            "supply_date": 2736262,
            "expire_date": 3838243
        }},
        {"Certificate": {
            "id": "CERTIFICATE_123",
            "supplier": "1",
            "quantity": 100,
            "is_jeju": true,
            "supply_date": 2736262,
            "expire_date": 3838243
        }},
        {"Certificate": {
            "id": "CERTIFICATE_456",
            "supplier": "1",
            "quantity": 100,
            "is_jeju": false,
            "supply_date": 2736262,
            "expire_date": 3838243
        }},
        {"Certificate": {
            "id": "CERTIFICATE_123",
            "supplier": "1",
            "quantity": 100,
            "is_jeju": true,
            "supply_date": 2736262,
            "expire_date": 3838243
        }},
        {"Certificate": {
            "id": "CERTIFICATE_456",
            "supplier": "1",
            "quantity": 100,
            "is_jeju": false,
            "supply_date": 2736262,
            "expire_date": 3838243
        }},
        {"Certificate": {
            "id": "CERTIFICATE_123",
            "supplier": "1",
            "quantity": 100,
            "is_jeju": true,
            "supply_date": 2736262,
            "expire_date": 3838243
        }},
        {"Certificate": {
            "id": "CERTIFICATE_456",
            "supplier": "1",
            "quantity": 100,
            "is_jeju": false,
            "supply_date": 2736262,
            "expire_date": 3838243
        }}
    ]
    """
}
