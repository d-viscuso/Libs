//
//  CreditCardValidator.swift
//  VFGMVA10Framework
//
//  Created by Atta Amed on 8/30/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// Class helps you to validate the most common credit card providers
/// verifying length, CVV and expiry dates and checking the card number through the Luhn algorithm
open class CreditCardValidator: CreditCardValidatorProtocol {
    public init() {}

    func expiryDateValidation(dateStr: String) -> Bool {
        let currentYear = Calendar.current.component(.year, from: Date()) % 100
        let currentMonth = Calendar.current.component(.month, from: Date())

        let enteredYear = Int(dateStr.suffix(2)) ?? 0
        let enteredMonth = Int(dateStr.prefix(2)) ?? 0

        if enteredYear > currentYear {
            return (1 ... 12).contains(enteredMonth)
        } else if currentYear == enteredYear {
            if enteredMonth >= currentMonth {
                return (1 ... 12).contains(enteredMonth)
            } else {
                return false
            }
        } else {
            return false
        }
    }
    func isValidDateFormat(dateStr: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/YY"
        return dateFormatter.date(from: dateStr) != nil
    }

    public func isValidNameOnCredit(_ name: String) -> Bool {
        if !name.isEmpty {
            return true
        }
        return false
    }

    public func isValidExpiryDate(_ date: String) -> Bool {
        if isValidDateFormat(dateStr: date), expiryDateValidation(dateStr: date) {
            return true
        }
        return false
    }

    public func isValidCVV(_ cvv: String, cardType: CardType?) -> Bool {
        if cardType == .amex {
            return cvv.count == maxLengthForCardCVV
        } else {
            return cvv.count == 3
        }
    }
    public func isValidCreditCardNumber(_ number: String) -> (type: CardType, valid: Bool) {
        return validateCreditCardFormat(number: number)
    }

    public func isValidCreditCardName(_ name: String) -> Bool {
        if !name.isEmpty {
            return true
        }
        return false
    }
    public var maxLengthForCardNumber: Int {
        return 16
    }

    public var maxLengthForCardCVV: Int {
        return 4
    }

    public var maxLengthForCardExpiry: Int {
        return 5
    }
    public var notAllowedCharacters: String {
        return "\"!#$%&()*,/:;<=>?][^`{|}~\\@•+_.1234567890£¥€"
    }
    public var allowedCharacters: String {
        return "1234567890"
    }
}

extension CreditCardValidator {
    /// Validate card number format using the Luhn algorithm
    public func validateCreditCardFormat(number: String) -> (type: CardType, valid: Bool) {
        var type: CardType = .unknown
        var formatted = ""
        var valid = false
        // detect card type
        for card in CardType.allCards where matchesRegex(regex: card.regex, text: number) {
            type = card
            break
        }
        valid = luhnCheck(number: number)
        var formatted4 = ""
        for character in number {
            if formatted4.count == 4 {
                formatted += formatted4 + " "
                formatted4 = ""
            }
            formatted4.append(character)
        }
        formatted += formatted4
        return (type, valid)
    }

    func matchesRegex(regex: String, text: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let match = regex.firstMatch(
                in: text,
                options: [],
                range: NSRange(location: 0, length: nsString.length)
            )
            return (match != nil)
        } catch {
            return false
        }
    }

    func luhnCheck(number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed().map { String($0) }

        for (index, char) in digitStrings.enumerated() {
            guard let digit = Int(char) else {
                return false
            }
            let odd = index % 2 == 1

            switch (odd, digit) {
            case (true, 9):
                sum += 9
            case (true, 0...8):
                sum += (digit * 2) % 9
            default:
                sum += digit
            }
        }
        return sum % 10 == 0
    }
}
