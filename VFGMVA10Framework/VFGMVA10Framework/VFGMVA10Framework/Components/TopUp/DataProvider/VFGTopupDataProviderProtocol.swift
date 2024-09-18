//
//  VFGTopupDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 1/17/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// TopUp data provider protocol.
public protocol VFGTopUpDataProviderProtocol {
    /// Method called after fetching topUp dashboard card data.
    /// - Parameters:
    ///    - completion: Completion of *VFGDashboardTopUpModelProtocol?* when fetching is successful and *Error?* when fetching fails.
    func fetchDashboardCardData(completion: @escaping (VFGDashboardTopUpModelProtocol?, Error?) -> Void)
}
