//
//  VFGManageAccountDelegate.swift
//  VFGMVA10Framework
//
//  Created by Ayman Ata on 29/12/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Delegate for the manage account journey.
public protocol VFGManageAccountDelegate: AnyObject {
    /// Tells delegate to re-present the manage account screen.
    func representManageAccount()
    /// Tells delegate to present the switch account screen.
    /// - Parameters:
    ///   - theme: Switch account theme.
    func presentSwitchAccount(theme: VFSwitchAccount)
    /// Tells delegate to rename an account with a new name.
    /// - Parameters:
    ///   - account: Account that should be renamed.
    ///   - newName: New name that user typed for that account.
    ///   - completion: A block object to be executed when renaming account ends,
    /// - Note: You must return a boolean value to determine if saving account name was successful or not.
    ///  If you don't return a value with completion, the loading screen will not be dismissed.
    func rename(account: VFGAccount, newName: String, completion: @escaping (Bool) -> Void)
    /// Tells delegate to remove an account with user's accounts.
    /// - Parameters:
    ///   - account: Account that should be removed.
    ///   - completion: A block object to be executed when removing account ends,
    /// - Note: You must return a boolean value to determine if saving account name was successful or not.
    ///  If you don't return a value with completion, the loading screen will not be dismissed.
    func remove(account: VFGAccount, completion: @escaping (Bool) -> Void)
}
