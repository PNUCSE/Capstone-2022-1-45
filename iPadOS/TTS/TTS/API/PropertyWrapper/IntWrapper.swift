//
//  IntWrapper.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/07.
//

import Foundation

@propertyWrapper
struct IntWrapper {
    let wrappedValue: Int
}

extension IntWrapper: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try? container.decode(String.self)
        if value == nil {
            let value1 = try? container.decode(Int.self)
            wrappedValue = Int(value1 ?? -1)
        } else {
            wrappedValue = Int(value ?? "-1") ?? -1
        }
    }
}

import Foundation

@propertyWrapper
struct OptionalIntWrapper {
    let wrappedValue: Int?
}

extension OptionalIntWrapper: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try? container.decode(String.self)
        if value == nil {
            let value1 = try? container.decode(Int.self)
            if value1 == nil {
                wrappedValue = nil
            } else {
                wrappedValue = Int(value1!)
            }
        } else {
            if value == nil {
                wrappedValue = nil
            } else {
                wrappedValue = Int(value!)
            }
        }
    }
}
