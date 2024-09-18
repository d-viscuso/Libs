//
//  VFGPayBillStateManagerProtocol.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 11/17/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Pay Bill Manager Protocol
/// The protocols holds the action for presenting and hiding auto bill view
public protocol VFGPayBillStateManagerProtocol: AnyObject {
    /// show pay bill view with provided model
    func presentPayBill(model: VFQuickActionsModel)
    /// dismiss the pay bill view with state 
    func closePayBill(with state: Bool)
}
