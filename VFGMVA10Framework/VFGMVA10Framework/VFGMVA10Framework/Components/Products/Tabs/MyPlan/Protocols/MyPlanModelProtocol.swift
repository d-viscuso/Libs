//
//  File.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 1/31/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// My plan model protocol.
public protocol MyPlanModelProtocol: Codable {
    /// Active plan services instance.
    var activePlanServices: ActivePlanServices? { get }
}
