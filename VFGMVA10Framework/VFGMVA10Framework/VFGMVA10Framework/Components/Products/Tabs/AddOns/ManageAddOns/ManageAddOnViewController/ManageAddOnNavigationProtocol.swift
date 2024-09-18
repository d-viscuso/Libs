//
//  ManageAddOnNavigationProtocol.swift
//  VFGMVA10Framework
//
//  Created by Amr Koritem on 03/08/2022.
//

import VFGMVA10Foundation

public typealias NavigationAction = (UIViewController) -> Void

/// ManageAddOnNavigationProtocol to handle custom navigation
public protocol ManageAddOnNavigationProtocol: AddOnsNavigationControlProtocol {
    /// to control the back action after removing an addon
    /// - Parameters:
    ///     - addOnIdentifier: Determine addon identifier.
    /// - Returns:
    ///     - the navigation action to be done provided the current view controller
    func popAfterRemoveAddOnAction(addOnIdentifier: String) -> NavigationAction?
    /// to control the back action after buying an addon
    /// - Parameters:
    ///     - addOnIdentifier: Determine addon identifier.
    /// - Returns:
    ///     - the navigation action to be done provided the current view controller
    func popAfterBuyAddOnAction(addOnIdentifier: String) -> NavigationAction?
}

public extension ManageAddOnNavigationProtocol {
    func popAfterRemoveAddOnAction(addOnIdentifier: String) -> NavigationAction? {
        { viewController in
            viewController.navigationController?.popViewController(animated: true)
        }
    }

    func popAfterBuyAddOnAction(addOnIdentifier: String) -> NavigationAction? {
        { viewController in
            viewController.navigationController?.popToRootViewController(animated: true)
        }
    }

    func buyAddOnNavigationType<T>(viewController: UIViewController, _ model: T) -> AddOnNavigationType {
        return .defaultNavigation
    }
}
