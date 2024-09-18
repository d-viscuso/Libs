//
//  PaymentCardDetails.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 10/6/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// Struct that represents payment card details.
public struct PaymentCardDetails {
    public var cardName: String
    public var cardNumber: String
    public var expiry: String
    public var cvv: String
    public var nameOnCard: String
    public var brand: CardType?
    public var customCardNumberView: Any?
    public var customCvvView: Any?
    public var isTempCard: Bool
    public init(
        cardName: String,
        cardNumber: String,
        expiry: String,
        cvv: String,
        nameOnCard: String,
        brand: CardType? = nil,
        customCardNumberView: Any? = nil,
        customCvvView: Any? = nil,
        isTempCard: Bool = false
    ) {
        self.cardName = cardName
        self.cardNumber = cardNumber
        self.expiry = expiry
        self.cvv = cvv
        self.nameOnCard = nameOnCard
        self.brand = brand
        self.customCardNumberView = customCardNumberView
        self.customCvvView = customCvvView
        self.isTempCard = isTempCard
    }
}
