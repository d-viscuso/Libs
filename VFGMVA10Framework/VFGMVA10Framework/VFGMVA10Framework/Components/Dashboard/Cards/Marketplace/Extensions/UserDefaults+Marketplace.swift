//
//  UserDefaults+Marketplace.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 20/10/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

extension UserDefaults: VFGMarketplaceWishlistProtocol {
    private enum Keys {
        static let productWishlist = "productWishlist"
    }

    private var productWishlist: [String] {
        get {
            return array(forKey: Keys.productWishlist) as? [String] ?? []
        }
        set {
            set(newValue, forKey: Keys.productWishlist)
        }
    }

    @discardableResult
    public func addProductToWishlist(product: VFGMarketplaceProductModel) -> Bool {
        if !wishlistContainsProduct(product: product) {
            productWishlist.append(product.productId)
            return true
        }
        return false
    }

    @discardableResult
    public func removeProductFromWishList(product: VFGMarketplaceProductModel) -> Bool {
        let result = wishlistContainsProduct(product: product)
        productWishlist.removeAll { $0 == product.productId }
        return result
    }

    @discardableResult
    public func wishlistContainsProduct(product: VFGMarketplaceProductModel) -> Bool {
        productWishlist.contains { $0 == product.productId }
    }

    public func reseMarketplaceUserDefaults() {
        removeObject(forKey: Keys.productWishlist)
    }
}
