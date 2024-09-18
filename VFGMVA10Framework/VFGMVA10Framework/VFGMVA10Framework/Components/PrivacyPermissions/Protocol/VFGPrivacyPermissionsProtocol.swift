//
//  VFGPrivacyPermissionsProtocol.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 26/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Protocol for Privacy Permissions actions
public protocol VFGPrivacyPermissionsProtocol: AnyObject {
    /// Close Button action
    func closeButtonDidPressed()
    /// Happy Button action 
    func happyButtonDidPressed()
    /// Accept All Button action
    func acceptAllButtonDidPressed(viewController: VFGPrivacyPermissionViewController)
    /// Reject All Button action
    func rejectAllButtonDidPressed(viewController: VFGPrivacyPermissionViewController)
}

public extension VFGPrivacyPermissionsProtocol {
    func rejectAllButtonDidPressed(viewController: VFGPrivacyPermissionViewController) {}
}

/// Protocol to update state and navigate to dashboard
public protocol PrivacyPermissionsNavigationProtocol: AnyObject {
    /// Close and navigate to dashboard action
    func closeButtonDidPressed()
}
