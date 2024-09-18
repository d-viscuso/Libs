//
//  VFGAddPlanStateManagerProtocol.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 7/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Add plan state manager protocol.
public protocol VFGAddPlanStateManagerProtocol: AnyObject {
    /// Present add plan quick action.
    /// - Parameters:
    ///    - viewModel: Qick action model *VFQuickActionsModel*.
    func presentAddPlan(model: VFQuickActionsModel)
    /// Setup add plan view type.
    /// - Parameters:
    ///    - planType: Plan type whether *data, sms or calls*.
    func setupAddPlanView(planType: AddPlanType)
}
