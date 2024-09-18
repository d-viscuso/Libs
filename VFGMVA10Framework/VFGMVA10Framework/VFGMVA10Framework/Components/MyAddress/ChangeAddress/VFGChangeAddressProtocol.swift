//
//  VFGChangeAddressProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 1/3/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Change address protocol
public protocol VFGChangeAddressProtocol: AnyObject {
    /// List of countries
    var countries: [String]? { get }
    /// List of cities
    var cities: [String]? { get }
    /// Validate that all addressModel items are not empty.
    /// - Parameters:
    ///   - model: Tray view controller that will be presented when you press on the tray button.
    ///   - completion: Completion with true if the model is valid & false if the model is not vaild.
    func validate(model: VFGAddressModel, completion: (Bool) -> Void)
    func saveButtonAction(model: VFGAddressModel, completion: @escaping (Bool) -> Void)

    /// Action that fired after clicked on resultView primary button
    /// - Parameters:
    ///     - viewController: Controller which contain result quickAction view
    func resultViewPrimaryButtonAction(_ viewController: UIViewController)
    /// Action that fired after clicked on resultView X button
    /// - Parameters:
    ///     - viewController: Controller which contain result quickAction view
    func resultViewCloseButtonAction(_ viewController: UIViewController)
}

public extension VFGChangeAddressProtocol {
    var cities: [String]? {
        nil
    }
    var countries: [String]? {
        nil
    }

    func resultViewPrimaryButtonAction(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func resultViewCloseButtonAction(_ viewController: UIViewController) {
        viewController.navigationController?.popToRootViewController(animated: true)
    }
}
