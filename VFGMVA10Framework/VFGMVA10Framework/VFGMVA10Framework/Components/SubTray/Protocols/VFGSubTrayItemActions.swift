//
//  VFGSubTrayItemActions.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 24/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Delegation protocol for sub tray item actions
public protocol VFGSubTrayItemActions: AnyObject {
    /// Handle expanding sub tray item
    /// - Parameters:
    ///    - item: Given sub tray item to be expanded
    ///    - completion: A closure to handle actions after expanding sub tray item
    func expand(_ item: VFGSubTrayItem, completion: (() -> Void)?)
    /// Handle collapsing sub tray item
    /// - Parameters:
    ///    - item: Given sub tray item to be collapsed
    ///    - completion: A closure to handle actions after collapsing sub tray item
    func collapse(_ item: VFGSubTrayItem, completion: (() -> Void)?)
    /// Determine current sub tray item status whether expanded or collapsed
    ///    - item: Given sub tray item to determine its status
    /// - Returns: True if item is expanded and false if not
    func isItemExpanded(_ item: VFGSubTrayItem) -> Bool
}

public extension VFGSubTrayItemActions {
    /// Handle expanding sub tray item
    /// - Parameters:
    ///    - item: Given sub tray item to be expanded
    func expand(_ item: VFGSubTrayItem) {
        expand(item, completion: nil)
    }
    /// Handle collapsing sub tray item
    /// - Parameters:
    ///    - item: Given sub tray item to be collapsed
    func collapse(_ item: VFGSubTrayItem) {
        collapse(item, completion: nil)
    }
}
