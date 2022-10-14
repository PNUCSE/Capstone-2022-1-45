//
//  IntUtility.swift
//  TTS
//
//  Created by Yujin Cha on 2022/09/14.
//

import Foundation

extension Int {
    func getFormattedString() -> String {
        let numberFormatter = NumberFormatter().then {
            $0.numberStyle = .decimal
        }
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

