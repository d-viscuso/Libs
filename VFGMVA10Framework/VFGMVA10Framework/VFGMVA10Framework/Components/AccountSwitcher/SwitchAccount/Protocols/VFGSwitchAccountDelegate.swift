//
//  VFGSwitchAccountDelegate.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 12/20/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
import UIKit
/// Protocol for *VFGSwitchAccountViewController* actions
public protocol VFGSwitchAccountDelegate: AnyObject {
    /// Adding a new account operation handler
    /// if this closure value is nil, then the add account button will be hidden and the cancel button will be shown
    var addAccountActionHandler: (() -> Void)? { get }
    /// manage accounts operation handler
    /// if this closure value is nil, then the add account button will be hidden and the cancel button will be shown
    var manageAccountsActionHandler: (() -> Void)? { get }
    /// Switching account operation will start
    /// - Parameters:
    ///    - account: Selected account to switch to
    func switchAccountWillStart(for account: VFGAccount)
    /// Switching account operation completed
    /// - Parameters:
    ///    - account: New current account
    func switchAccountDidComplete(for account: VFGAccount)
    /// log out operation handler
    func logOutDidPressed()
}

public extension VFGSwitchAccountDelegate {
    var addAccountActionHandler: (() -> Void)? {
        nil
    }

    var manageAccountsActionHandler: (() -> Void)? {
        nil
    }

    func logOutDidPressed() { /* Default impelementation, do nothing*/ }
}
