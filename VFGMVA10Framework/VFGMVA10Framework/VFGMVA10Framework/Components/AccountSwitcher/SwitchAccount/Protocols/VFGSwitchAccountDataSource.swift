//
//  VFGSwitchAccountDataSource.swift
//  VFGMVA10Framework
//
//  Created by Adel Aref on 07/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// Protocol for *VFGSwitchAccountActionsProtocol* switch account actions proprites
public protocol VFGSwitchAccountDataSource: AnyObject {
    /// Configuring add account icon
    var addAccountIcon: UIImage? { get }
    /// Configuring manage account icon
    var manageAccountIcon: UIImage? { get }
    /// Configuring add account title
    var addAccountTitle: String? { get }
    /// Configuring manage account icon
    var manageAccountTitle: String? { get }
    /// log  out button title
    var logOutButtonTitle: String? { get }
    /// Configuring add account visiblity
    var isAddAccountButtonHidden: Bool? { get }
    /// Configuring manage account visiblity
    var isManageAccountButtonHidden: Bool? { get }
    /// hide Log Out Button
    var isLogOutButtonHidden: Bool? { get }
}

public extension VFGSwitchAccountDataSource {
    var addAccountIcon: UIImage? {
        VFGFrameworkAsset.Image.manageAccount
    }
    var manageAccountIcon: UIImage? {
        VFGFrameworkAsset.Image.redSetttings
    }
    var addAccountTitle: String? {
        "Add an account"
    }
    var manageAccountTitle: String? {
        "Manage accounts on this device"
    }
    var logOutButtonTitle: String? {
        "logout_button".localized(bundle: Bundle.mva10Framework)
    }
    var isAddAccountButtonHidden: Bool? {
        false
    }
    var isManageAccountButtonHidden: Bool? {
        false
    }
    var isLogOutButtonHidden: Bool? {
        false
    }
}
