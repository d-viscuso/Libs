//
//  ActivePlanServicesProtocol.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 9/9/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// Active plan services protocol.
public protocol ActivePlanServicesProtocol: Codable {
    /// Primary plan.
    var primaryPlan: PrimaryPlanServiceProtocol? { get }
}
