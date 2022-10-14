//
//  BoolWrapper.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/14.
//

import Foundation

@propertyWrapper
struct BoolWrapper {
    let wrappedValue: Bool
}

extension BoolWrapper: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        var value = try? container.decode(String.self)
        if value == nil {
            var value1 = try? container.decode(Bool.self)
            wrappedValue = Bool(value1 ?? false) ?? false
        } else {
            wrappedValue = Bool(value ?? "false") ?? false
        }
    }
}
