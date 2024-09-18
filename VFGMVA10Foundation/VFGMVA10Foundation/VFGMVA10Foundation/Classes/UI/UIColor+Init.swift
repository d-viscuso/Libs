//
//  UIColor+Init.swift
//  VFGMVA10Foundation
//
//  Created by Hamsa Hassan on 9/11/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension UIColor {
    /**
    Base initializer, creates an instance of `UIColor` using a HEX string

    - Parameter hex: The base HEX string to create the color
    - Parameter alpha: The opacity value from 0 to 1
    */
    public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        guard let hex = hexString.hexToInt() else {
            return nil
        }
        self.init(red: hex.red / 255.0, green: hex.green / 255.0, blue: hex.blue / 255.0, alpha: alpha)
    }
}

private extension Int {
    var red: CGFloat {
        return CGFloat((self & 0xFF0000) >> 16)
    }

    var green: CGFloat {
        return CGFloat((self & 0xFF00) >> 8)
    }

    var blue: CGFloat {
        return CGFloat(self & 0xFF)
    }
}

private extension String {
    enum Const {
        static let prefix = "0x"
        static let hash = "#"
        static let empty = ""
    }
    /// Remove prefix from hex
    func removePrefix() -> String {
        let formatted = replacingOccurrences(of: Const.prefix, with: Const.empty)
        return formatted.replacingOccurrences(of: Const.hash, with: Const.empty)
    }

    /// Convert hex to decimal integer
    func hexToInt() -> Int? {
        guard let hex = Int(removePrefix(), radix: 16) else {
            return nil
        }
        return hex
    }
}
