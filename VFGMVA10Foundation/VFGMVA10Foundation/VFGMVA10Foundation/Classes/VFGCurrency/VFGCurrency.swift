//
//  VFGCurrency.swift
//  VFGMVA10Group
//
//  Created by Mohamed Sayed on 21/03/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/**
`VFGCurrency` is a class that take care of amount of money provided. It can format the amount into
custom currency, depending on the 'CurrencyFormatterProtocol' provided.
*/
open class VFGCurrency {
    /// Delegate for custom currency formatter.
    public weak var delegate: CurrencyFormatterProtocol?
    /// Amount of money.
    public var amount: NSNumber
    /// Returns the formatted amount.
    /// Note that if there is no custom delegate provided (CurrencyFormatterProtocol), the format would be in defualt currency.
    public var formatted: String? {
        if let externalDelegate = delegate {
            return externalDelegate.getFormattedCurrency(amount)
        } else {
            return getFormattedCurrency(amount)
        }
    }

    /// Initialize the VFGCurrency with the amount wanted.
    public init(amount: NSNumber) {
        self.amount = amount
    }
}

extension VFGCurrency: CurrencyFormatterProtocol {
    public func getFormattedCurrency(_ amount: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedAmount = formatter.string(from: amount as NSNumber) {
            return formattedAmount
        }
        return ""
    }
}
