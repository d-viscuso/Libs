//
//  MyAddressManager.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 03/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// My address Manager
public class VFGMyAddressManager {
    public static var myAddressProvider: MyAddressProviderProtocol?
    public static var myAddress: VFGAddressModel?
    public static weak var changeAddressDelegate: VFGChangeAddressProtocol?
    public static weak var listAddressDelegate: VFGDeleteAddressProtocol?
    public static var showEditButton = true
    public static var showDeleteButton = false
    public static var showPostCode = true
    var shouldShowCode = true
    // MARK: - Navigation
    /// Call this method to navigate *MyAddressViewController*.
    public class func navigateToMyAddressViewController() {
        guard let myAddressViewController = myAddressProvider?.myAddressViewController else {
            return
        }
        myAddressViewController.delegate = VFGMyAddressManager.listAddressDelegate
        let navController = MVA10NavigationController(rootViewController: myAddressViewController)
        navController.setTitle(
            title: "my_address_screen_title".localized(bundle: .mva10Framework),
            for: myAddressViewController
        )
        navController.setAccessibilityLabels(
            closeButtonLabel: "Close",
            titleAccessibilityLabel: "My address")
        navController.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
    }

    /// Call this method to navigate *VFGChangeAddressViewController*.
    public class func navigateToChangeAddressViewController(navigation: MVA10NavigationController?) {
        guard let changeAddressViewController = myAddressProvider?.changeAddressViewController else {
            return
        }
        changeAddressViewController.delegate = VFGMyAddressManager.changeAddressDelegate
        navigation?.setTitle(
            title: "change_address_screen_title".localized(bundle: .mva10Framework),
            for: changeAddressViewController
        )
        navigation?.setAccessibilityLabels(
            closeButtonLabel: "Close",
            backButtonLabel: "Back",
            titleAccessibilityLabel: "Change address")
        navigation?.pushViewController(changeAddressViewController, animated: true)
    }
}
