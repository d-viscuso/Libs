//
//  PaymentDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 8/25/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
public typealias FetchPaymentCompletion = (([PaymentModelProtocol]?, Error?) -> Void)?
public typealias ManagePaymentCompletion = (AddPaymentErrorModel?) -> Void

/// Data provider protocol used by container to fetch all payment cards and set the preferred one
public protocol PaymentDataProviderProtocol {
    /// Fetch payment cards.
    /// - Parameters:
    ///    - completion: *FetchPaymentCompletion* is a typealias for *(([PaymentModelProtocol]?, Error?) -> Void)?*.
    func fetchPaymentCards(completion: FetchPaymentCompletion)
    /// Set a specific card as preferred payment card. Will be used in any transaction in case the user has more than one card.
    /// - Parameters:
    ///    - paymentId: Preferred card's Id.
    ///    - completion: *FetchPaymentCompletion* is a typealias for *(([PaymentModelProtocol]?, Error?) -> Void)?*.
    func setPreferredPaymentCard(paymentId: String, completion: FetchPaymentCompletion)
    /// Number of cards.
    var numberOfCards: Int { get }
}
