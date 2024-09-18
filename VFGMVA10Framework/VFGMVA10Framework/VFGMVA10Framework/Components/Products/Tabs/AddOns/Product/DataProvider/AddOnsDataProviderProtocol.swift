//
//  AddOnsDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 6/24/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

/// AddOns data provider protocol.
public protocol AddOnsDataProviderProtocol {
    /// Manage products delegate.
    var manageProductsDelegate: ManageProductsDelegate? { get set }
    /// Fetch products action.
    /// - Parameters:
    ///     - completion: *FetchAddOnsCompletion* is a typealis for *((AddOnsProductsProtocol?, Error?) -> Void)?*
    func fetchMyProducts(completion: FetchAddOnsCompletion)
}

/// Manage products delegate
public protocol ManageProductsDelegate: AnyObject {
    /// Update products action.
    /// - Parameters:
    ///     - products: A list of *AddOnsProductModel*
    func updateProducts(_ products: [AddOnsProductModel])
}
