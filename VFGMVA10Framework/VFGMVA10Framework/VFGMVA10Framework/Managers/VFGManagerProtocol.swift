//
//  VFGManagerProtocol.swift
//  VFGMVA10Group
//
//  Created by Omar Khaled Ali on 9/26/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//
import VFGMVA10Foundation

/// Framework manager.
public enum VFGManagerFramework {
    /// Application settings delegate.
    static public var appSettingsDelegate: VFGAppSettingsProtocol?
    /// Dashboard delegate.
    static public var dashboardDelegate: VFGDashboardProtocol?
    /// Tray delegate.
    static public var trayDelegate: VFGTrayProtocol?
    /// Purchase delegate.
    static public var purchaseDelegate: VFGPurchaseProtocol?
    /// Tobi delegate.
    static public var tobiDelegate: VFGTobiProtocol?
    /// Everything is ok delegate.
    static public var eioDelegate: VFGEIOProtocol?
    /// State delegate.
    static public var stateDelegate: VFGStateProtocol?
    /// Fun fact delegate.
    static public var funFactDelegate: VFGFunFactDelegate?
    static var count = 0
}
