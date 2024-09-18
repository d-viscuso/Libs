//
//  VFGPayBillProtocol.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 11/17/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// *VFGPayBillProtocol* is a protocol that is responsible for requesting payment of bill and validating the card used
public protocol VFGPayBillProtocol: AnyObject {
    /// model object
    var model: VFGPayBillActionModelProtocol? { get }
    /// Check if partially paid mode enabled to make changes in pay bill view UI 
    var isPartiallyPaidModeEnabled: Bool? { get }
    func setup(completion: @escaping (Error?) -> Void)

    /// Method for paying bill
    /// - Parameters:
    ///    - billValue: The amount of the bill
    ///    - completion: The closure that contains the bill payment state
    func requestPayBill(
        billValue: Double?,
        completion: @escaping (
        _ success: Bool?) -> Void
    )

    /// Method for verifying the payment card
    /// - Parameters:
    ///    - withOffer: The offer contained in the payment process
    ///    - completion: The closure that contains the bill payment state and the new balance after bill deduction from the card balance
    func requestCardVerification(
        withOffer: Bool,
        completion: @escaping (
        _ success: Bool?,
        _ newBalance: Int?) -> Void
    )
}

extension VFGPayBillProtocol {
    public var isPartiallyPaidModeEnabled: Bool? {
        false
    }
}
