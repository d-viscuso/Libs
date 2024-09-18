//
//  VFGTrayViewController+VFGTrayActionsDelegate.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 15/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension VFGTrayViewController: VFGTrayActionsDelegate {
    public func selectTrayItem(_ trayItem: VFGTrayItemModel) {
        trayItemPressed(trayItem: trayItem)
    }
}
