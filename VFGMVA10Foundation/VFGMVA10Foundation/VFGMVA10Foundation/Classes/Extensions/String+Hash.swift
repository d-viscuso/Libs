//
//  String+Hash.swift
//  VFGMVA10Foundation
//
//  Created by Erdem ILDIZ on 26.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
import CommonCrypto

public extension String {
    /// Hashes or Encrypts the String object and returns the new encrypted string.
    ///
    /// - Returns: A new *String* of the hashed original string.
    func sha256() -> String {
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }

    private func digest(input: NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }

    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)

        var hexString = ""
        for byte in bytes {
            hexString += String(format: "%02x", UInt8(byte))
        }
        return hexString
    }
    /// hash String with Asterisk
    func hashWithAsterisk(uncoveredCharCount: Int = 3) -> String {
        guard self.count > uncoveredCharCount else { return self }
        var secureDigits = ""
        for _ in 0...self.count - (uncoveredCharCount + 1) {
            secureDigits += "*"
        }
        secureDigits.append(String(self.suffix(uncoveredCharCount)))
        return secureDigits
    }
}
