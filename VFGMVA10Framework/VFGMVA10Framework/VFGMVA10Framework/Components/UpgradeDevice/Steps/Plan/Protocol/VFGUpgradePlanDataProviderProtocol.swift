//
//  VFGUpgradePlanDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 5/19/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Upgrade Plan Data Fetching Protocol
public protocol VFGUpgradePlanDataProviderProtocol: AnyObject {
    /// Method that is called to fetch upgrade device plans.
    ///     - Parameters:
    ///     - completion: contains the fetched Upgrade model or Error if could't fetch model.
    func fetchPlans(completion: @escaping ((VFGUpgradePlanModel?, Error?) -> Void))
}
