//
//  MarketplaceViewModel.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 10/10/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// MarketplaceViewModelProtocol
public protocol VFGMarketplaceViewModelProtocol {
    /// number of products
    var numberOfProducts: Int { get }
    /// product's array
    var products: [VFGMarketplaceProductModel] { get }
    /// shows/hide see all button
    var showSeeAllButton: Bool { get }
    /// returns the product at given index
    /// - Parameter index: index of the product's array
    /// - Returns: the product at given index if present
    func productAtIndex(index: Int) -> VFGMarketplaceProductModel?
}

/// MarketplaceViewModel
public class VFGMarketplaceViewModel {
    /// product's array
    public let products: [VFGMarketplaceProductModel]
    /// constructor
    /// - Parameter products: the list of the products
    public init(products: [VFGMarketplaceProductModel]) {
        self.products = products
    }
}

extension VFGMarketplaceViewModel: VFGMarketplaceViewModelProtocol {
    /// number of products
    public var numberOfProducts: Int {
        products.count
    }
    /// shows/hides see all button (configurable by the market)
    public var showSeeAllButton: Bool {
        true
    }
    /// returns the product at given index
    /// - Parameter index: index of the product's array
    /// - Returns: the product at given index if present
    public func productAtIndex(index: Int) -> VFGMarketplaceProductModel? {
        guard index >= 0, index < products.count else {
            return nil
        }
        return products[index]
    }
}
