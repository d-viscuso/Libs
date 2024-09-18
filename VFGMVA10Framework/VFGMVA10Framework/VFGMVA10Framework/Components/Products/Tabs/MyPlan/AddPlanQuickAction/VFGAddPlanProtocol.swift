//
//  VFGAddPlanProtocol.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 7/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
public typealias FetchAddPlanCompletion = ((Error?) -> Void)

/// Add plan protocol.
public protocol VFGAddPlanProtocol: AnyObject {
    var model: VFGAddPlanModelProtocol? { get }

    /// Function used to setup addPlanModel
    /// - Parameters:
    ///   - planType: The plan type (data or SMS)
    ///   - completion: Tells the delegate that setup addPlanModel finished
    func setup(
        _ planType: AddPlanType,
        completion: @escaping FetchAddPlanCompletion
    )

    /// Function that gets triggered when the user adds a plan (data or SMS) and sends information about this plan
    /// - Parameters:
    ///   - selectedRow: Selected row in my plan
    ///   - isRecurring: Identify if added plan is one off or recurring
    ///   - completion: Tells the delegate that add plan request finished
    func requestPlan(
        selectedRow: Int,
        isRecurring: Bool,
        completion: @escaping (_ success: Bool?) -> Void
    )

    /// Function used to verify selected card
    /// - Parameters:
    ///   - selectedRow: Selected card row
    ///   - completion: Tells the delegate that verifying card finished
    func requestCardVerification(
        selectedRow: Int,
        completion: @escaping (_ success: Bool?) -> Void
    )
}
