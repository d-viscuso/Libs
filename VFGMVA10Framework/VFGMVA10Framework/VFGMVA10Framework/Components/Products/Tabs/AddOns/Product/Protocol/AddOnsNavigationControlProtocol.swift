//
//  AddOnsNavigationControlProtocol.swift
//  VFGMVA10Framework
//
//  Created by Amr Koritem on 21/06/2022.
//

/// AddOnsNavigationControlProtocol to handle custom navigation logic
public protocol AddOnsNavigationControlProtocol: AnyObject {
    /// Method that confirms custom navigation for the selected addon.
    /// - Parameters:
    ///     - selectedAddon: The addon selected that caused the navigation
    /// - Returns:
    ///     - navigation type for the selected addon
    func buyAddOnNavigationType<T>(viewController: UIViewController, _ model: T) -> AddOnNavigationType
}

/// AddOnNavigationType representing navigation logic type
public enum AddOnNavigationType {
    /// Choose this if you want to make the navigation goes normally
    case defaultNavigation
    /// Choose this if you want to make custom navigation and supply your navigation logic
    case customNavigation(() -> Void)
}
