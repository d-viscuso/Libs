//
//  ShopAddOnsDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 6/24/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
public typealias FetchAddOnsCompletion = ((AddOnsProductsProtocol?, Error?) -> Void)?

/// Shop AddOns data provider protocol.
public protocol ShopAddOnsDataProviderProtocol {
    /// Method to fetch all products for addOns Shop.
    /// - Parameters:
    ///     - completion: A list of *AddOnsProductModel*
    func fetchAllProducts(completion: FetchAddOnsCompletion)
    func customView() -> UIView?
}
public extension ShopAddOnsDataProviderProtocol {
    func customView() -> UIView? { nil }
}
