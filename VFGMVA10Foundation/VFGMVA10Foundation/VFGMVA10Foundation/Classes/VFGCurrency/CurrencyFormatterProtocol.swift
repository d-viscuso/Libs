//
//  CurrencyFormatterProtocol.swift
//  VFGMVA10Group
//
//  Created by Mohamed Sayed on 22/03/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// `CurrencyFormatterProtocol` is abstract currency formatter that should be adopted to provide custom currency format (eg: Euro, Lira .. etc)
public protocol CurrencyFormatterProtocol: AnyObject {
    /// Formatting the provided amount of money and returns the formatted amount as string.
    /// - Parameters:
    ///   - amount: Amount of money that would be formatted.
    func getFormattedCurrency(_ amount: NSNumber) -> String
}
