//
//  VFGVerticalSubTrayView+VFGSubTrayExpandedItemDelegate.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 08/11/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension VFGVerticalSubTrayView: VFGSubTrayExpandedItemDelegate {
    func itemDidPress(_ view: VFGSubTrayExpandedItemView, _ model: VFGSubTrayExpandedItemModel) {
        guard
            let highlightedItemIndex = highlightedItemIndex,
            let subItem = filteredDataSource?.items?[safe: highlightedItemIndex] else {
            return
        }
        subItem.expandedItemAction(
            VFGManagerFramework.trayDelegate?.subTrayItemsActions(.expandedItem(subItem, model), nil)
        )
    }
}
