//
//  VFGSubTrayExpandedItemDelegate.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 24/10/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Delegation protocol for sub tray expanded view actions
protocol VFGSubTrayExpandedItemDelegate: AnyObject {
    /// Sub tray expanded view item press action
    /// - Parameters:
    ///    - view: Sub tray expanded view collection view cell pressed container view
    ///    - model: Sub tray expanded view pressed item model
    func itemDidPress(_ view: VFGSubTrayExpandedItemView, _ model: VFGSubTrayExpandedItemModel)
}
