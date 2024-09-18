//
//  SubTrayCustomizationManagerNavigationDelegate.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 23/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Delegation protocol for *SubTrayCustomizationManager* navigation actions
protocol SubTrayCustomizationManagerNavigationDelegate: AnyObject {
    /// Handle the next screen to be presented based on current state
    /// - Parameters:
    ///    - state: Current state for sub tray customization journey
    func finish(state: SubTrayCustomizationManagerState)
    /// Handle dismiss action based on current state
    /// - Parameters:
    ///    - state: Current state for sub tray customization journey
    func terminate(state: SubTrayCustomizationManagerState)
}
