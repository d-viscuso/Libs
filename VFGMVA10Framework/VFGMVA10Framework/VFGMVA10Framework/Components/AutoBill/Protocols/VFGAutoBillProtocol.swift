//
//  VFGAutoBillProtocol.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 31/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Protocol for auto bill quick actions
public protocol VFGAutoBillProtocol: AnyObject {
    /// An instance of *VFGAutoBillActionModelProtocol*
    var model: VFGAutoBillActionModelProtocol? { get set }
    /// Auto bill setup
    /// - Parameters:
    ///    - completion: A closure to handle success or failure state actions
    func setup(completion: @escaping (Error?) -> Void)
    /// API request for auto bill process
    /// - Parameters:
    ///    - selectedDay: Selected day for auto bill payment
    ///    - completion: A closure to handle success or failure state actions
    func requestAutoBill(
        selectedDay: Int?,
        completion: @escaping (
        _ success: Bool?) -> Void
    )
    /// API request for auto bill process
    /// - Parameters:
    ///    - withOffer: Determine if the selected amount comes with an offer gift or not
    ///    - completion: A closure to handle success or failure state actions and having the new balance
    func requestCardVerification(
        withOffer: Bool,
        completion: @escaping (
        _ success: Bool?,
        _ newBalance: Int?) -> Void
    )
}
