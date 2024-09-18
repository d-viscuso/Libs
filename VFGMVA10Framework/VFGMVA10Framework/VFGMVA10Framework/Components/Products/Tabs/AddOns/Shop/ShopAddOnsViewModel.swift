//
//  ShopAddOnsViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 5/4/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Shop addOns view model.
public class ShopAddOnsViewModel {
    var reloadProducts: (() -> Void)?
    var reloadCategories: (([String]) -> Void)?
    var shopAddOnDataProvider: ShopAddOnsDataProviderProtocol
    var allProducts: [AddOnsProductModel] = []
    var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    var updateLoadingStatus: (() -> Void)?

    private(set) var filteredProducts: [AddOnsProductModel] = [] {
        didSet {
            reloadProducts?()
        }
    }

    private(set) var addOnsCategories: [String] = []

    public init(shopAddOnDataProvider: ShopAddOnsDataProviderProtocol) {
        self.shopAddOnDataProvider = shopAddOnDataProvider
    }

    func numberOfProducts() -> Int {
        return filteredProducts.count
    }

    func product(at index: Int) -> AddOnsProductModel {
        return filteredProducts[index]
    }

    func filter(with addOnsTypesStrings: [String]) {
        var addOnsTypes: [String] = []
        for addOnTypyStr in addOnsTypesStrings {
            addOnsTypes.append(addOnTypyStr)
        }
        filteredProducts = self.allProducts.filter { product in
            if addOnsTypes.contains(AddOnsTypeLocalize.all.localizedString) {
                return true
            } else {
                return addOnsTypes.contains { addOnType in
                    return addOnType == product.addonType
                }
            }
        }
    }

    func fetchAllProducts() {
        contentState = .loading
        self.shopAddOnDataProvider.fetchAllProducts { [weak self] allProducts, error in
            guard let self = self else {
                return
            }
            guard let allAddOns = allProducts?.addOns, error == nil else {
                self.contentState = .error
                return
            }
            self.allProducts = allAddOns
            self.filteredProducts = allAddOns
            let existingTypes = allAddOns.compactMap { $0.addonType }.unique()
            self.addOnsCategories = [AddOnsTypeLocalize.all.localizedString] + Array(existingTypes)
            self.contentState = .populated
        }
    }

    func isPromProduct(at indexPath: IndexPath) -> Bool {
        if contentState == .populated {
            return filteredProducts[indexPath.row].isPromoAddon
        }
        return false
    }
}
