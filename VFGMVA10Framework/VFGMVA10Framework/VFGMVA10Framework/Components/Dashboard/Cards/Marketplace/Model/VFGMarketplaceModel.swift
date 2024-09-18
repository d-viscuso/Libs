//
//  MarketplaceModel.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 07/10/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation


/// MarketplaceModel: model used to configure MarketplaceView
public struct VFGMarketplaceModel: Codable {
    /// list of marketplace products items
    public var productList: [VFGMarketplaceProductModel]?
}


/// MarketplaceProductModel: model used to configure a single product
public struct VFGMarketplaceProductModel: Codable {
    /// the product id
    var productId: String
    /// the name of the product
    var productName: String
    /// shows or not the add to wishlist button
    var showWish: Bool?
    /// product image
    var productImageUrl: String
    /// product's happy points value
    var happyPoints: Int?
    /// product price
    var currentPrice: Double?
    /// product former price
    var formerPrice: Double?
    /// product price currency
    var currency: String?
}
