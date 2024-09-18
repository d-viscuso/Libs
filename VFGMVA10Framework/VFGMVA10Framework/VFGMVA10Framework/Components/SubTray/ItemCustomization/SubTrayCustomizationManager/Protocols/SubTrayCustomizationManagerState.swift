//
//  SubTrayCustomizationManagerState.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 23/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// List of states for sub tray customization journey
enum SubTrayCustomizationManagerState {
    case customization(newName: String, isDefault: Bool)
    case verification
    case quickActionsConfirmation
    case loading(status: Bool)
    case success
    case failure
}
