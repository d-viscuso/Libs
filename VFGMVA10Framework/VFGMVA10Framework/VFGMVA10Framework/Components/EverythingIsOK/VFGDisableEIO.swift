//
//  VFGEIODisable.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Mahmoud Zaki on 3/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// Disable EIO Model
public class VFGDisableEIO: VFGEIOModelProtocol {
    /// EIO dashboard protocol
    public weak var dashboardManagerDelegate: VFGDashboardManagerProtocol?
    /// EIO Model
    public weak var model: EverythingIsOkModel?
    /// EIO Status
    public var eioStatus: EIOStatus = .success
    /// Updated Item number
    public var updatedItem: Int?
    /// EIO Manager Protocol
    public weak var EIOManagerDelegate: VFGEIOManagerProtocol?
    /// Pull to show ability status
    public var pullToShowEIO = false
    /// EIO Enabled status
    public var isEIOEnabled: Bool? = false
    /// EIO Broadcast Changes method
    public func broadcastEIOKChanges() {}
    /// Disabled EIO Setup 
    public func setup() {
        dashboardManagerDelegate?.EIOSetupFinished(error: nil)
    }
    public init() {}
}
