//
//  VFGFloatingTobiBadgeModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Tuncel, Pelin, Vodafone on 7/27/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

public protocol VFGFloatingTobiBadgeModelProtocol: AnyObject {
    /// Badge count
    var badgeCount: Int { get set }
    /// Badge id
    var badgeId: String { get set }
}
