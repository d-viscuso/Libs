//
//  ProductsViewControllerDelegate.swift
//  VFGMVA10Framework
//
//  Created by Amr El Shazly on 09/03/2023.
//  Copyright © 2023 Vodafone. All rights reserved.
//

import Foundation

/// Products View Controller Delegate
public protocol ProductsViewControllerDelegate: AnyObject {
    /// A call back methoid to detect which tab is selected
    /// - Parameter indexPath: index path of the selected tab
    func selectTabViewController(at indexPath: IndexPath)
}
