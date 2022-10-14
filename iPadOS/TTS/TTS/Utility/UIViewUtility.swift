//
//  UIViewUtility.swift
//  TTS
//
//  Created by Lee Jun Young on 2022/09/04.
//

import UIKit

extension UIView {
    func setShadow() {
        self.layer.cornerRadius = 5.0
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 3, height:3)
    }
}
