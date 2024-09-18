//
//  AddOnsProductViewModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 4/12/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

extension AddOnsViewModel: ManageProductsDelegate {
    public func updateProducts(_ products: [AddOnsProductModel]) {
        myPromProduct = nil
        setMyProductsAndMyPromProduct(products: products)
        shouldRefresh = true
    }
}

/// AddOns view model.
public class AddOnsViewModel {
    /// AddOns data provider.
    var addOnsDataProvider: AddOnsDataProviderProtocol?
    /// AddOns products list.
    var myProducts: [AddOnsProductModel]?
    var myPromProduct: AddOnsProductModel? {
        didSet {
            updateMyPromProduct?()
        }
    }
    /// determines if timeLineView is hidden
    public var isTimeLineViewHidden = false
    /// AddOns CVM model.
    var addOnCVM: AddOnsCVMModelProtocol?
    /// AddOns CVM data provider.
    var addOnCVMDataProvider: AddOnsCVMDataProviderProtocol?
    /// Boolean to show or hide addOns inline content, default is false.
    public var shouldShowAddOnsInlineContent = false
    /// enable refresh
    public var enableRefresh: Bool
    /// Products content state *empty, loading, etc*.
    var productContentState: VFGContentState = .empty {
        didSet {
            updateProductLoadingStatus?()
        }
    }
    /// AddOns CVM content state *empty, loading, etc*.
    var cvmContentState: VFGContentState = .empty {
        didSet {
            updateCVMLoadingStatus?()
        }
    }
    var shouldRefresh = false
    var updateProductLoadingStatus: (() -> Void)?
    var updateCVMLoadingStatus: (() -> Void)?
    var updateMyPromProduct: (() -> Void)?

    /// *AddOnsViewModel* initializer.
    /// - Parameters:
    ///     - addOnsDataProvider: AddOns data provider *AddOnsDataProviderProtocol*.
    ///     - isTimeLineViewHidden: Show and hide timeline view
    ///     - enableRefresh: Enable refresh
    public init(
        addOnsDataProvider: AddOnsDataProviderProtocol,
        isTimeLineViewHidden: Bool = false,
        enableRefresh: Bool = false
    ) {
        self.addOnsDataProvider = addOnsDataProvider
        self.enableRefresh = enableRefresh
        self.addOnsDataProvider?.manageProductsDelegate = self
        self.addOnCVMDataProvider = self.addOnsDataProvider as? AddOnsCVMDataProviderProtocol
        self.isTimeLineViewHidden = isTimeLineViewHidden
    }

    func fetchMyProducts() {
        productContentState = .loading
        guard let addOnsDataProvider = addOnsDataProvider else {
            self.productContentState = .empty
            return
        }
        addOnsDataProvider.fetchMyProducts { [weak self] myProducts, error in
            guard let self = self else {
                return
            }

            guard let myAddOns = myProducts?.addOns, error == nil else {
                self.productContentState = .error
                return
            }
            self.setMyProductsAndMyPromProduct(products: myAddOns)
            self.productContentState = .populated
        }
    }

    func numberOfMyProducts() -> Int {
        return myProducts?.count ?? 0
    }

    func myProduct(at index: Int) -> AddOnsProductModel? {
        if index > (myProducts?.count ?? 0) - 1 {
            return AddOnsProductModel(
                title: "",
                subTitle: "",
                imageName: "",
                addonType: "",
                addOnDetails: AddOnPlanDetails(
                    title: "",
                    description: "",
                    startDate: "",
                    expirationDate: "",
                    priceDetails: "",
                    price: ""),
                identifier: ""
            )
        }
        return myProducts?[index]
    }

    func fetchAddonsCVM() {
        cvmContentState = .loading
        guard let addOnCVMDataProvider = addOnCVMDataProvider else {
            self.cvmContentState = .empty
            return
        }
        addOnCVMDataProvider.fetchAddOnsCVM { [weak self] addOn, error in
            guard let self = self else { return }
            guard let model = addOn,
                error == nil else {
                self.cvmContentState = .error
                return
            }

            self.addOnCVM = model
            self.cvmContentState = .populated
        }
    }

    func numberOfAddOnsCVM() -> Int {
        return addOnCVM?.identifier != nil && shouldShowAddOnsInlineContent ? 1 : 0
    }

    func setMyProductsAndMyPromProduct(products: [AddOnsProductModel]) {
        myProducts = products
        myPromProduct = products.first(where :) { $0.isPromoAddon && !($0.isSellable) }
        for (index, element) in products.enumerated() where element.identifier == myPromProduct?.identifier {
            myProducts?.remove(at: index)
        }
    }
}
