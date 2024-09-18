//
//  SubTrayCustomizationManagerDelegate.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 23/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Delegation protocol for *SubTrayCustomizationManager* actions
public protocol SubTrayCustomizationManagerDelegate: AnyObject {
    /// Handle cancellation action for customization view controller
    func customizationViewControllerCancelAction()
    /// Handle cancellation action for verification view controller
    func verificationViewControllerCancelAction()
    /// Handle updating sub tray item data
    /// - Parameters:
    ///    - item: Sub tray item to be updated
    ///    - newTitle: Sub tray item new title
    ///    - isDefault: Determine if sub tray item is the default item or not
    ///    - completion: A closure to handle actions after updating sub tray item data
    func updateItemData(
        item: VFGSubTrayItem,
        newTitle: String,
        isDefault: Bool,
        completion: @escaping (Bool) -> Void
    )
    /// Check if entered pin code is valid or not
    /// - Parameters:
    ///    - code: Entered pin code
    /// - Returns: True if entered code is valid and false if not
    func checkPinCodeValidation(with code: String) -> Bool
}
