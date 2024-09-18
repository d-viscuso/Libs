//
//  VFGFloatingTobiBadgeModel.swift
//  VFGMVA10Framework
//
//  Created by Tuncel, Pelin, Vodafone on 7/27/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import UIKit

public class VFGFloatingTobiBadgeModel: VFGFloatingTobiBadgeModelProtocol {
    /// Badge count
    public var badgeCount: Int
    /// Badge id
    public var badgeId: String

    public init(
        badgeCount: Int = 0,
        badgeId: String = "TobiNotificationBadgeId"
    ) {
        self.badgeCount = badgeCount
        self.badgeId = badgeId
    }
}
