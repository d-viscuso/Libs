//
//  VFGTopupActionModel.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 2/18/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// TopUp action model protocol.
public protocol VFGTopupActionModelProtocol {
    /// List of related parties.
    var relatedParty: [RelatedPartyProtocol]? { get }
    /// Default payment method.
    var defaultPaymentMethod: PaymentMethodProtocol? { get }
    /// List of amounts the user can topUp with.
    var amounts: [Double]? { get }
    /// List of specific gifted amounts.
    var specificGiftedAmounts: [Double]? { get }
    /// Currency.
    var currency: String? { get }
    /// Minimum amount of topUp to get offer.
    var minOfferAmount: Double? { get }
    /// Balance.
    var balance: Double? { get }
    /// Data offer amount.
    var dataOfferAmount: Double? { get }
    /// Offer amount.
    var offerAmount: Double? { get }
    /// Offer description.
    var offerDescription: String? { get }
    /// Data unit *GB, MB*.
    var dataUnit: String? { get }
    /// Remaining data.
    var remainingData: String? { get }
    /// Offer price.
    var offerPrice: Int? { get }
    /// Offer end date.
    var offerEndDate: String? { get }
    /// Boolean determines if this offer is timed or not.
    var timedOffer: Bool? { get }
    /// MSISDN.
    var msisdn: String? { get }
    /// Boolean determines whether to show the currency on left or right of the amount.
    var isIconRTL: Bool? { get }
    /// Subtitle.
    var subtitle: String? { get }
    /// Amount threshold.
    var amountThreshold: Int { get }
    /// Initial selected amount from the available topUp *amounts* list.
    var initialSelectedAmount: Double? { get }
}

/// Related party protocol.
public protocol RelatedPartyProtocol {
    /// User Id.
    var userId: String? { get }
    /// Name.
    var name: String? { get }
}

/// Payment method protocol.
public protocol PaymentMethodProtocol {
    /// Payment Id.
    var paymentId: String? { get }
    /// Payment details model.
    var details: PaymentDetailsProtocol? { get }
}

/// Payment Details protocol.
public protocol PaymentDetailsProtocol {
    /// Brand.
    var brand: String? { get }
    /// Last four digits.
    var lastFourDigits: String? { get }
}

extension VFGTopupActionModelProtocol {
    public var specificGiftedAmounts: [Double]? {
        nil
    }
    public var amountThreshold: Int {
        0
    }
    public var initialSelectedAmount: Double? {
        nil
    }
}
