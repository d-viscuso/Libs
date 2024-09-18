//
// Navajo.swift
// Navajo
//
// Copyright (c) 2015-2017 Jason Nam (http://jasonnam.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

/// Strength of password. There are five levels divided by entropy value.
/// The entropy value is evaluated by information entropy theory.
public enum PasswordStrength: Int {
    case empty = 0
    /// Entropy value is smaller than 28
    case veryWeak
    /// Entropy value is between 28 and 35
    case weak
    /// Entropy value is between 36 and 45
    case medium
    /// Entropy value is between 45 and 60
    case reasonable
    /// Entropy value is between 61 and 90
    case good
    /// Entropy value is between 91 and 127
    case strong
    /// Entropy value is larger than 127
    case veryStrong
}

/// Navajo validates strength of passwords.
enum Navajo {
    /// Gets strength of a password.
    ///
    /// - parameter password: Password string to be calculated
    ///
    /// - returns: Level of strength in NJOPasswordStrength
    public static func strength(ofPassword password: String) -> PasswordStrength {
        return passwordStrength(forEntropy: entropy(of: password))
    }

    private static func entropy(of string: String) -> Float {
        guard !string.isEmpty else {
            return 0
        }

        var includesLowercaseCharacter = false,
            includesUppercaseCharacter = false,
            includesDecimalDigitCharacter = false,
            includesPunctuationCharacter = false,
            includesSymbolCharacter = false,
            includesWhitespaceCharacter = false,
            includesNonBaseCharacter = false

        var sizeOfCharacterSet: Float = 0

        string.enumerateSubstrings(
            in: string.startIndex ..< string.endIndex,
            options: .byComposedCharacterSequences
        ) { subString, _, _, _ in
            guard let unicodeScalars = subString?.first?.unicodeScalars.first else {
                return
            }

            if !includesLowercaseCharacter && CharacterSet.lowercaseLetters.contains(unicodeScalars) {
                includesLowercaseCharacter = true
                sizeOfCharacterSet += 26
            }

            if !includesUppercaseCharacter && CharacterSet.uppercaseLetters.contains(unicodeScalars) {
                includesUppercaseCharacter = true
                sizeOfCharacterSet += 26
            }

            if !includesDecimalDigitCharacter && CharacterSet.decimalDigits.contains(unicodeScalars) {
                includesDecimalDigitCharacter = true
                sizeOfCharacterSet += 10
            }

            if !includesSymbolCharacter && CharacterSet.symbols.contains(unicodeScalars) {
                includesSymbolCharacter = true
                sizeOfCharacterSet += 10
            }

            if !includesPunctuationCharacter && CharacterSet.punctuationCharacters.contains(unicodeScalars) {
                includesPunctuationCharacter = true
                sizeOfCharacterSet += 20
            }

            if !includesWhitespaceCharacter && CharacterSet.whitespacesAndNewlines.contains(unicodeScalars) {
                includesWhitespaceCharacter = true
                sizeOfCharacterSet += 1
            }

            if !includesNonBaseCharacter && CharacterSet.nonBaseCharacters.contains(unicodeScalars) {
                includesNonBaseCharacter = true
                sizeOfCharacterSet += 32 + 128
            }
        }

        return log2f(sizeOfCharacterSet) * Float(string.count)
    }

    private static func passwordStrength(forEntropy entropy: Float) -> PasswordStrength {
        if entropy == 0 {
            return .empty
        } else if entropy < 28 {
            return .veryWeak
        } else if entropy < 36 {
            return .weak
        } else if entropy < 46 {
            return .medium
        } else if entropy < 61 {
            return .reasonable
        } else if entropy < 91 {
            return .good
        } else if entropy < 128 {
            return .strong
        } else {
            return .veryStrong
        }
    }
}
