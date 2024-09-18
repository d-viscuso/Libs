//
//  CreditCardValidatorProtocol.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 9/23/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// Validate credit card details
public protocol CreditCardValidatorProtocol: AnyObject {
    /// Validate the card number
    /// - Parameter number: Card number
    /// - Returns
    ///   - type:  The `CardType`
    ///   - valid:  A Boolean value indicating if the card number is valid or not
    func isValidCreditCardNumber(_ number: String) -> (type: CardType, valid: Bool)

    /// Validate the card name
    /// - Parameter name: A distinctive name for the card for easy identification
    /// - Returns: A Boolean value indicating if the card name is valid or not
    func isValidCreditCardName(_ name: String) -> Bool

    /// Validate the name on the card
    /// - Parameter name: The name written in the card
    /// - Returns: A Boolean value indicating if the name on the card is valid or not
    func isValidNameOnCredit(_ name: String) -> Bool

    /// Validate the card expiry date
    /// - Parameter date: Card expiry date as `String`
    /// - Returns: A Boolean value indicating if the card expiry date is valid or not
    func isValidExpiryDate(_ date: String) -> Bool

    /// Validate the CVV number
    /// It takes credit card type in consideration because this varies between 3 and 4 digits depending on the card
    /// - Parameter cvv: Card CVV
    /// - Parameter cardType: The `CardType`

    /// - Returns: A Boolean value indicating if the card cvv is valid or not
    func isValidCVV(_ cvv: String, cardType: CardType?) -> Bool

    /// Not allowed characters in the text field
    var notAllowedCharacters: String { get }
    /// Allowed characters in the text field
    var allowedCharacters: String { get }

    /// Card number max length
    var maxLengthForCardNumber: Int { get }

    /// Card CVV max length
    var maxLengthForCardCVV: Int { get }

    /// Card expiry date max length
    var maxLengthForCardExpiry: Int { get }
}
