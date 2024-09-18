//
//  VFGDashboardManagerProtocol.swift
//  VFGMVA10Group
//
//  Created by Mahmoud Amer on 8/8/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//
import Foundation
import UIKit

/// Dashboard manager protocol.
public protocol VFGDashboardManagerProtocol: AnyObject {
    /// Action to navigate to second level screenw that is called when you press on a card on dashboard.
    /// - Parameters:
    ///     - controller: Error if an error ocuured while setting up EIO.
    func presentSecondLevel(with controller: UIViewController)
    /// Method that is called when EIO finishes it's setup.
    /// - Parameters:
    ///     - error: Error if an error ocuured while setting up EIO.
    func EIOSetupFinished(error: Error?)
    /// Method that is called when dashboard items are set up.
    /// - Parameters:
    ///     - error: Error if an error ocuured while setting up dashboard items.
    func dashboardItemsSetupFinished(error: Error?)
    /// Reload *VFDashboardViewController* items
    /// - Parameter itemsIndices: *Array* of IndexPath of items to be refreshed
    func reloadItems(at itemsIndices: [IndexPath])
    /// Reload *VFDashboardViewController* sections
    /// - Parameter indexSet: indexSet of sections to be refreshed
    func reloadSections(at indexSet: IndexSet)
    /// Method that is called to reload the dashboard
    func reloadDashboard()
}
// MARK: - VFGDashboardManagerProtocol + default implementations
public extension VFGDashboardManagerProtocol {
    func reloadItems(at itemsIndices: [IndexPath]) {}
    func reloadSections(at indexSet: IndexSet) {}
    func reloadDashboard() {}
}
