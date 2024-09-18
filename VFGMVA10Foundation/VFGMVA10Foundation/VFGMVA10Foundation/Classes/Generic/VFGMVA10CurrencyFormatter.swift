//
//  VFGMVA10CurrencyFormatter.swift
//  VFGMVA10Foundation
//
//  Created by Hussien Gamal Mohammed Fahmy on 04/03/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// `VFGMVA10CurrencyFormatter` is class that provide simple interface to handle currency formats.
public class VFGMVA10CurrencyFormatter {
    public enum Format: String {
        case comma
        case prefix
        case postfix
    }

    var bundle: Bundle?
    /// Creates new instance from the given bundle.
    /// - Parameters:
    ///    - bundle: Your current bundle.
    public init(bundle: Bundle?) {
        self.bundle = bundle
    }

    /// Creates and returns new string depending on the given properties.
    /// - Parameters:
    ///    - leftSideSign: Boolean value to tell if the sign would be on left or not, it is true by default.
    ///    - amount: Amount of money.
    ///    - sign: Sign that would be added (eg: $).
    ///    - hasComma: Boolean value to tell if the string replaces period "." with comma ",".
    /// - Returns: A new *String* contains the given amount and formatted to the given attributes.
    func currencyFormat(
        leftSideSign: Bool = true,
        amount: String,
        sign: String,
        hasComma: Bool = false
    ) -> String {
        let priceFormat = "%1$@%2$@"
        var formattedAmount = amount
        if hasComma {
            formattedAmount = formattedAmount.replacingOccurrences(of: ".", with: ",")
        }
        let currencyStrings = leftSideSign ? [sign, formattedAmount] : [formattedAmount, sign]
        return String(format: priceFormat, arguments: currencyStrings)
    }

    /// Builds new currency  string depending on the given properties.
    /// - Parameters:
    ///    - mode: Mode of the format.
    ///    - amount: Amount of money.
    ///    - sign: Sign that would be added (eg: $).
    /// - Returns: A new *String* contains the given amount and formatted depending on the given mode.
    func buildCurrencyString(
        mode: VFGMVA10CurrencyFormatter.Format?,
        amount: String,
        sign: String
    ) -> String {
        switch mode {
        case .comma?:
            return currencyFormat(
                leftSideSign: false,
                amount: amount,
                sign: sign,
                hasComma: true)
        case .postfix?:
            return currencyFormat(
                leftSideSign: false,
                amount: amount,
                sign: sign,
                hasComma: false)
        case .prefix?:
            return currencyFormat(
                leftSideSign: true,
                amount: amount,
                sign: sign,
                hasComma: false)
        default:
            return currencyFormat(
                leftSideSign: false,
                amount: amount,
                sign: sign,
                hasComma: false)
        }
    }

    /// Formates the given amount depending on the given mode.
    /// - Parameters:
    ///    - amount: Amount of money.
    ///    - sign: Sign that would be added (eg: $).
    ///    - mode: Mode of the format.
    /// - Returns: A new *String* contains the given amount and formatted depending on the given mode.
    public func formatAmountToString(
        amount: String,
        sign: String,
        mode: VFGMVA10CurrencyFormatter.Format? = nil
    ) -> String {
        let keyName = "currency_format_mode"
        let formatModeString = keyName.localized(bundle: bundle)
        let formatMode = VFGMVA10CurrencyFormatter.Format(rawValue: formatModeString)
        return buildCurrencyString(
            mode: mode ?? formatMode,
            amount: amount,
            sign: sign)
    }
}
