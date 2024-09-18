//
//  VFGSubTrayActionType.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 24/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// List of sub tray actions type
public enum VFGSubTrayActionType {
    /// Sub tray item action
    case subTrayItem(VFGSubTrayItem)
    /// Sub tray customization action
    case customization(VFGSubTrayItem)
    /// Sub tray item expandation action
    case expandedItem(VFGSubTrayItem, VFGSubTrayExpandedItemModel)
}
