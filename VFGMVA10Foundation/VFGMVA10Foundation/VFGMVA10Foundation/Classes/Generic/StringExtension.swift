//
//  StringExtension.swift
//  VFGMVA10
//
//  Created by Hussien Gamal Mohammed on 7/9/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

internal extension String {
    /// Checks if the string object has a new line symbol.
    var hasOnlyNewlineSymbols: Bool {
        return trimmingCharacters(in: CharacterSet.newlines).isEmpty
    }

    /// Checks if the string object has white space.
    var containsWhitespace: Bool {
        return rangeOfCharacter(from: .whitespacesAndNewlines) != nil
    }

    /// Checks if the string object's length is lesser than the given length.
    /// - Parameters:
    ///    - length: Length that would be compared to the string length.
    /// - Returns: A *Bool* value to indicate if the text is lesser than the given length.
    func tooShortText(_ length: Int) -> Bool {
        return count < length
    }
}

public extension String {
    /// Converts this string based 64 to a regular String object.
    /// - Returns: A *String?* of the converted 64 base string.
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    /// Converts this string to a String based 64 object.
    /// - Returns: A *String* of the converted string.
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

    /// Trims this string from unique characters.
    ///
    /// Note that the characters that would be removed are space, comma, single quote mark and exclamation mark.
    /// - Returns: A *String* free from unique characters.
    func trimSpaceAndUniqueCharacters() -> String {
        self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "!", with: "")
            .replacingOccurrences(of: ",", with: "")
    }

    /// Returns an array containing all the matches of the regular expression in the string.
    /// - Returns: A *[String]?* of the potential matches.
    func matches(with regex: String) -> [String]? {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let value = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: value.length))
            return results.map { value.substring(with: $0.range) }
        } catch {
            return nil
        }
    }
}
