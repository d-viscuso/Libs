//
//  VFGVerticalSubTrayViewDataSourceItem.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 08/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// List of vertical sub tray items status collapsed or expanded
enum VFGVerticalSubTrayViewDataSourceItem {
    /// Collapsed item case
    /// - Parameters:
    ///    - item: Collapsed item
    case item(_ item: VFGSubTrayItem)
    /// Expanded item case
    /// - Parameters:
    ///    - parentId: Item id
    ///    - item: Expanded item
    case expandedItem(parentId: String, _ item: VFGSubTrayExpandedItemModel)
}

extension VFGVerticalSubTrayViewDataSourceItem {
    /// Collapsed item
    var item: VFGSubTrayItem? {
        switch self {
        case .item(let item):
            return item
        default:
            return nil
        }
    }
    /// Expanded item
    var expandedItem: VFGSubTrayExpandedItemModel? {
        switch self {
        case .expandedItem(_, let expandedItem):
            return expandedItem
        default:
            return nil
        }
    }
    /// Determine if current item is expanded or collapsed
    var isExpandedItem: Bool {
        switch self {
        case .expandedItem:
            return true
        default:
            return false
        }
    }
    /// Expanded Item id
    var expandedItemParentId: String? {
        switch self {
        case .expandedItem(let parentId, _):
            return parentId
        default:
            return nil
        }
    }
}
