//
//  VFGTopUpProtocol.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 1/16/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// TopUp protocol.
public protocol VFGTopUpProtocol: AnyObject {
    /// TopUp model.
    var model: VFGTopupActionModelProtocol? { get }
    var isCustomTopUpFlow: Bool? { get }
    /// Mobile number validator instance.
    var validateMobileNumber: VFGContactNumberValidatorProtocol? { get }
    /// Protocol allows performing some actions to topUp view.
    var topUpActionsProtocol: VFGTopUpActionsProtocol? { get set }
    /// Setup method where you can instantiate objects or fetch data depending.
    /// - Parameters:
    ///    - completion: *(Error?) -> Void*.
    func setup(completion: @escaping (Error?) -> Void)
    /// Method that requests topUp with completion of the result if the topUp succeeded or failed.
    /// - Parameters:
    ///    - topUpValue: Value of topUp.
    ///    - withOffer: Boolean that determines if the topUp is with offer or not.
    ///    - completion: Completion of *(_ success: Bool?, _ newBalance: Int?) -> Void*, success is a boolean that determines if the topUp succeeded or failed and the new balance after the topUp.
    func requestTopUp(
        topUpValue: Double?,
        withOffer: Bool,
        completion: @escaping (
        _ success: Bool?,
        _ newBalance: Int?) -> Void
    )
    /// Method used to validate new added payment card.
    /// - Parameters:
    ///    - withOffer: Boolean that determines if the topUp is with offer or not.
    ///    - completion: Completion of *(_ success: Bool?, _ newBalance: Int?) -> Void*, success is a boolean that determines if the new added card is valid or not.
    func requestCardVerification(
        withOffer: Bool,
        completion: @escaping (
        _ success: Bool?,
        _ newBalance: Int?) -> Void
    )

    /// Method used to request a topUp for someone else.
    /// - Parameters:
    ///    - phoneNumber: The phone number of the someone else.
    ///    - completion: Completion of *(_ success: Bool, _ errorMessage: String?) -> Void*, success is a boolean that determines if the topUp succeeded or failed and errorMessage if the topUp failed.
    func requestTopupValidation(
        phoneNumber: String,
        completion: @escaping (
        _ success: Bool,
        _ errorMessage: String?) -> Void
    )
    /// Method triggered when someone else .
    /// - Parameter phoneNumber: The phone number of the someone else.
    func requestTopupSomeoneElse(with phoneNumber: String)
    /// Method called when the user changes the selected topUp amount.
    /// - Parameters:
    ///    - selectedAmount: New selected amount.
    ///    - topupButton: TopUp Button.
    func didChangedPickerValue(
        selectedAmount: Double,
        topupButton: VFGButton
    )
}

public extension VFGTopUpProtocol {
    var isCustomTopUpFlow: Bool? {
        false
    }

    var topUpActionsProtocol: VFGTopUpActionsProtocol? {
        get { nil }
        set { _ = newValue }
    }

    func requestTopupValidation(
        phoneNumber: String,
        completion: @escaping (
        _ success: Bool,
        _ errorMessage: String?) -> Void
    ) {
        completion(true, nil)
    }

    func requestTopupSomeoneElse(with phoneNumber: String) {}

    func didChangedPickerValue(
        selectedAmount: Double,
        topupButton: VFGButton
    ) {}
}
