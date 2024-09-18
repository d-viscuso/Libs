//
//  AddOnsManager.swift
//  VFGMVA10Group
//
//  Created by Esraa Eldaltony on 9/17/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// AddOns Manager
public class AddOnsManager {
    /// AddOns data provider
    var addOnsDataProvider: AddOnsDataProviderProtocol
    /// MyPlan data provider
    var myPlanDataProvider: MyPlanDataProviderProtocol
    /// Boolean to show or hide addOns inline content, default s false.
    var shouldShowAddOnsInlineContent = false

    public init(
        addOnsDataProvider: AddOnsDataProviderProtocol,
        myPlanDataProvider: MyPlanDataProviderProtocol,
        shouldShowAddOnsInlineContent: Bool = false
    ) {
        self.addOnsDataProvider = addOnsDataProvider
        self.myPlanDataProvider = myPlanDataProvider
        self.shouldShowAddOnsInlineContent = shouldShowAddOnsInlineContent
    }

    /// Method to return a fully initialized *AddOnsViewController*.
    /// - Parameters:
    ///   - navigationDelegate: Controls the navigation in `AddOnsViewController`
    ///   - shopNavigationDelegate: Controls the navigation in `ShopAddOnsViewController`
    ///   - manageAddOnUiDelegate: Controls the ui in `ManageAddOnViewController`
    ///   - manageAddOnNavigationDelegate: Controls the navigation in `ManageAddOnViewController`
    ///   - isTimeLineViewHidden: Determine if the timeline view will be shown
    ///   - enableRefresh: Determine if refresh is enabled
    /// - Returns:
    ///   - addOnsViewController referenced as `BaseTabsViewController`
    public func addonsController(
        navigationDelegate: AddOnsNavigationControlProtocol? = nil,
        manageAddOnUiDelegate: ManageAddOnUIDelegateProtocol? = nil,
        manageAddOnNavigationDelegate: ManageAddOnNavigationProtocol? = nil,
        isTimeLineViewHidden: Bool = false,
        enableRefresh: Bool = false
    ) -> BaseTabsViewController {
        let addOnsVC = AddOnsViewController()
        addOnsVC.addOnsViewModel = AddOnsViewModel(
            addOnsDataProvider: addOnsDataProvider,
            isTimeLineViewHidden: isTimeLineViewHidden,
            enableRefresh: enableRefresh)
        addOnsVC.myPlanDataProvider = myPlanDataProvider
        addOnsVC.addOnsViewModel?.shouldShowAddOnsInlineContent = shouldShowAddOnsInlineContent
        addOnsVC.navigationDelegate = navigationDelegate
        addOnsVC.manageAddOnUiDelegate = manageAddOnUiDelegate
        addOnsVC.manageAddOnNavigationDelegate = manageAddOnNavigationDelegate

        return addOnsVC
    }
}
