//
//  VFGSubTrayItem+Actions.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 24/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGSubTrayItem {
    func action(
        _ actions: VFGActions? = VFGManagerFramework.trayDelegate?.trayActions(),
        delegate: VFGSubTrayItemActions? = nil,
        expandedItem: VFGSubTrayExpandedItemModel? = nil
    ) {
        if let actionId = trayActionKey {
            if let action = actions?[actionId] {
                action()
            } else if let action =
                VFGManagerFramework.trayDelegate?.subTrayItemsActions(.subTrayItem(self), delegate)[actionId] {
                action()
            }
        } else {
            guard let action = trayAction else {
                VFGDebugLog("no trayAction for item:\(title ?? "--")")
                return
            }
            action()
        }
    }

    func customizeAction(_ actions: VFGActions?) {
        if let actionId = customizeActionKey,
            let action = actions?[actionId] {
            action()
        }
    }

    func expandedItemAction(_ actions: VFGActions?) {
        if let actionId = expandedItemActionKey,
            let action = actions?[actionId] {
            action()
        }
    }
}
