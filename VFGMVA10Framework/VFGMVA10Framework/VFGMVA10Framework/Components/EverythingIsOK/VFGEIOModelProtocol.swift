//
//  VFGEIOModelProtocol.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 8/28/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// EIO model protocol.
public protocol VFGEIOModelProtocol: AnyObject {
    /// Dashboard manager delegate.
    var dashboardManagerDelegate: VFGDashboardManagerProtocol? { get set }
    /// EIO model *EverythingIsOkModel*.
    var model: EverythingIsOkModel? { get set }
    /// EIO status *success, failed or inProgress*.
    var eioStatus: EIOStatus { get }
    /// Number of updated items.
    var updatedItem: Int? { get }
    /// EIO manager delegate.
    var EIOManagerDelegate: VFGEIOManagerProtocol? { get set }
    /// Boolean that determines if pull to show EIO action is enabled or not.
    var pullToShowEIO: Bool { get }
    /// Boolean that determines if EIO is enabled or not.
    var isEIOEnabled: Bool? { get }
    /// Mehtod is called to broadcast when there's a change in EIO.
    func broadcastEIOKChanges()
    /// EIO setup method.
    func setup()
}

/// EIO manager protocol.
public protocol VFGEIOManagerProtocol: AnyObject {
    /// Method that is called when there's a status update in EIO to delegate the update action to dashboard.
    func statusUpdated()
}
