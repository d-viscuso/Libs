//
//  AddPaymentProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 8/25/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

public typealias FetchCardCompletion = ((PaymentModelProtocol?, Error?) -> Void)?
public typealias PaymentProcessCompletion = (Error?) -> Void

/// Data provider protocol used by container to update, Add, fetch or remove a payment card
public protocol AddPaymentProviderProtocol {
    /// payment list controller.
    var paymentListViewController: UIViewController? { get }
    /// Add payment controller.
    var addPaymentViewController: UIViewController? { get }
    /// Edit payment controller.
    var editPaymentViewController: UIViewController? { get }
    /// Add new payment card.
    /// - Parameters:
    ///    - paymentCard: New payment card details.
    ///    - completion: *ManagePaymentCompletion* is a typealias for *(AddPaymentErrorModel?) -> Void*.
    func add(paymentCard: PaymentCardDetails, completion: @escaping ManagePaymentCompletion)
    /// Update the card details when the cardId already exist in stored cards list.
    /// - Parameters:
    ///    - paymentCard: Updated payment card details but the cardId should be the same.
    ///    - completion: *ManagePaymentCompletion* is a typealias for *(AddPaymentErrorModel?) -> Void*.
    func update(paymentCard: PaymentCardDetails, completion: @escaping ManagePaymentCompletion)
    /// Fetch a specific payment card.
    /// - Parameters:
    ///    - cardId: Required card's Id.
    ///    - completion: *FetchCardCompletion* is a typealias for *((PaymentModelProtocol?, Error?) -> Void)?*.
    func fetchPaymentCard(by cardId: String, completion: FetchCardCompletion)
    /// Delete a specific payment card.
    /// - Parameters:
    ///    - cardId: Required card's Id.
    ///    - completion: *ManagePaymentCompletion* is a typealias for *(AddPaymentErrorModel?) -> Void*.
    func deletePaymentCard(by cardId: String, completion: @escaping ManagePaymentCompletion)
    /// Pay a specific payment amount.
    /// - Parameters:
    ///    - amount: Payment amount.
    ///    - paymentCard: Card model that will be used in this transaction.
    ///    - completion: *(Error?) -> Void*.
    func pay(amount: Double, with paymentCard: PaymentModelProtocol, completion: @escaping PaymentProcessCompletion)
    /// Set auto bill.
    /// - Parameters:
    ///    - day: Day when the user will be charged for his/her bill.
    ///    - paymentCard: Card model that will be used in auto bill.
    ///    - completion: *(Error?) -> Void*.
    func autoBill(day: Int, with paymentCard: PaymentModelProtocol, completion: @escaping PaymentProcessCompletion)
    /// Set auto topUp.
    /// - Parameters:
    ///    - activeAutoTopUpModel: Auto topUp model.
    ///    - completion: *(Error?) -> Void*.
    func autoTopUp(activeAutoTopUpModel: VFGActiveAutoTopUpProtocol, completion: @escaping PaymentProcessCompletion)
}
