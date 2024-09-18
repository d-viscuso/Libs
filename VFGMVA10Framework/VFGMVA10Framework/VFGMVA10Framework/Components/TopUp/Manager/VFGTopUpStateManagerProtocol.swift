//
//  VFGTopUpStateManagerProtocol.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 1/16/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// TopUp state manager protocol.
public protocol VFGTopUpStateManagerProtocol: AnyObject {
    /// Method to present topUp quick action.
    /// - Parameters:
    ///    - model: TopUp quick action model.
    func presentTopup(model: VFQuickActionsModel)

    /// Method to event of the close topUp quick action.
    func topupDidCloseWithSuccess()
}

public extension VFGTopUpStateManagerProtocol {
    func topupDidCloseWithSuccess() { }
}
