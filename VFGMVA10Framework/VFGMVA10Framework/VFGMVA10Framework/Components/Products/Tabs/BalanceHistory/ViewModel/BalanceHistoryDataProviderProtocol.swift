//
//  BalanceHistoryDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 11/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

public typealias FetchBalanceFetchCompletion = ((BalanceHistoryModelProtocol?, Error?) -> Void)?

/// Balance History data provider protocol.
public protocol BalanceHistoryDataProviderProtocol {
    /// Method to fetch balance history in a specific date range.
    /// - Parameters:
    ///     - dateRange: A tuple of two dates.
    ///     - completion: *FetchBalanceFetchCompletion* is atypealias for *((BalanceHistoryModelProtocol?, Error?) -> Void)*
    func fetchBalanceHistory(dateRange: (from: Date, to: Date)?, completion: FetchBalanceFetchCompletion)
}
