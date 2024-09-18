//
//  VFGSubtrayBadgesProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 1/11/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Protocol to update badge view over sub tray items
protocol VFGSubtrayBadgesProtocol: AnyObject {
    /// If badges data exist, All related sub tray items will have badges with its data
    /// - Parameters:
    ///    - newBadges: Dictionary that holds all sub tray items badges data
    func badgeDidUpdate(newBadges: [String: BadgeModel]?)
}
