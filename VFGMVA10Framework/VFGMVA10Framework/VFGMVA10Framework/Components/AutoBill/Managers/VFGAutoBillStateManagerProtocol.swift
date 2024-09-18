//
//  VFGAutoBillStateManagerProtocol.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 31/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// *VFGAutoBillStateManager* protocol
public protocol VFGAutoBillStateManagerProtocol: AnyObject {
    /// Present auto bill quick action
    /// - Parameters:
    ///    - model: Auto bill quick action model
    func presentAutoBill(model: VFQuickActionsModel)
    /// Close auto bill quick action
    /// - Parameters:
    ///    - state: Auto bill current state
    ///    - selectedDay: Auto bill selected day to pay bill
    ///    - remainingDays: Auto bill number of remaining days to pay bill
    ///    - selectedCardNumber: Auto bill number of the card selected to pay bill with
    func closeAutoBill(with state: Bool, selectedDay: Int?, remainingDays: Int?, selectedCardNumber: String?)
}
