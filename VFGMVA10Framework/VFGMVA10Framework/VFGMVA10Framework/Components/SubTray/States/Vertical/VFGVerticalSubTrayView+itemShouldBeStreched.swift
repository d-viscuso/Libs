//
//  VFGVerticalSubTrayView+itemShouldBeStreched.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 08/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGVerticalSubTrayView {
    /// Determine if vertical sub tray item is expandable or not
    /// - Parameters:
    ///    - item: Given item to determine if it is expandable or not
    ///    - indexPath: Current index for given item
    /// - returns: True if given item is expandable and false if not
    func itemShouldBeStreched(_ item: VFGSubTrayItem?, at indexPath: IndexPath) -> Bool {
        let lastExpandableItem = filteredAndExpandedItemsUIModels?
            .lastIndex { $0.item?.isExpandableItem ?? false }
        let isLastExpandableItem = lastExpandableItem == indexPath.row
        if
            item?.hasExpandedItems ?? false &&
            indexPath.row % 2 == 0 &&
            indexPath.row >= highlightedItemIndex ?? Int.max &&
            isLastExpandableItem {
            return true
        }
        return false
    }
}
