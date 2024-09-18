//
//  VFGMultiTabsManager.swift
//  VFGMVA10Foundation
//
//  Created by Moataz Akram on 06/12/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Multi tabs manager
public class VFGMultiTabsManager {
    public static let shared = VFGMultiTabsManager()

    private init() {}

    /// A method responsible for create and setup multi tabs view controller
    /// - Parameters:
    ///     - headerViewModel: A header model to configure multi tabs header. Notice that if you passed nil, the header view will be hidden 
    ///     - isHeaderViewFixed: A boolean to control if the header is scrollable or fixed
    ///     - isSwipeGestureEnabled: A boolean to control if the tabs are swibable of not.
    /// - Returns: Multi tabs view controller object
    public func createMultiTabsController(
        headerViewModel: MultiTabsHeaderViewModel?,
        isHeaderViewFixed: Bool = false,
        isSwipeGestureEnabled: Bool = false
    ) -> VFGMultiTabsViewController {
        let tabsViewController: VFGMultiTabsViewController = UIViewController.instance(
            from: "MultiTabs",
            with: "VFGMultiTabsViewController",
            bundle: .foundation)
        tabsViewController.isSwipeGestureEnabled = isSwipeGestureEnabled
        tabsViewController.headerViewModel = headerViewModel
        tabsViewController.isHeaderViewFixed = isHeaderViewFixed
        return tabsViewController
    }
}
