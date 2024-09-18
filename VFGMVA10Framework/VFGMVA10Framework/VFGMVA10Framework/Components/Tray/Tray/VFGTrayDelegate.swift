//
//  VFGTrayDelegate.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 15/09/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public protocol VFGTrayDelegate: AnyObject {
    var trayActionsDelegate: VFGTrayActionsDelegate? { get set }
    func didSelectItem(_ trayItem: VFGTrayItemModel)
}

public protocol VFGTrayActionsDelegate: AnyObject {
    func selectTrayItem(_ trayItem: VFGTrayItemModel)
}
