//
//  VFPermissionViewModelProtcol.swift
//  VFGMVA10
//
//  Created by Hussien Gamal Mohammed on 7/2/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// Permission view model protocol.
protocol VFPermissionViewModelProtocol: AnyObject {
    /// Hide dependents permissions if parent's status is false.
    /// - Parameters:
    ///     - index: Permission index.
    func hideView(at index: Int)
    /// Show dependents permissions if parent's status is true.
    /// - Parameters:
    ///     - index: Permission index.
    func showView(at index: Int)
    /// Update the dependent permission state.
    /// - Parameters:
    ///     - state: New state of dependent permission if true or false.
    ///     - index: Permission index.
    func dependentPermissionStatusDidChange(state: Bool, index: Int)
    /// Is used to update the view.
    func permissionCardsDidSetup()
}

extension VFPermissionViewModelProtocol {
    func hideView(at index: Int) {}
    func showView(at index: Int) {}
    func dependentPermissionStatusDidChange(state: Bool, index: Int) { }
    func permissionCardsDidSetup() { }
}
