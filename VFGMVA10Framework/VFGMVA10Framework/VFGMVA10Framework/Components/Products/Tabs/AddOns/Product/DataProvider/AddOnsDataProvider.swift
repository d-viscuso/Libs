//
//  AddOnsDataProvider.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 6/24/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

// MARK: - myAddOns Data Provider
class AddOnsDataProvider: AddOnsDataProviderProtocol, ShopAddOnsDataProviderProtocol {
    public weak var manageProductsDelegate: ManageProductsDelegate?
    private var addOnDataProvider: VFGNetworkClientProtocol?
    public var myProducts: [AddOnsProductModel] = []
    public var allProducts: [AddOnsProductModel] = []
    var myAddOnsRequest: VFGRequest?
    var allAddOnsRequest: VFGRequest?
    var addOneCVMRequest: VFGRequest?
    var resultModel: VFGResultModelConfig?

    public init(
        myAddOnsRequest: VFGRequest?,
        allAddOnsRequest: VFGRequest?,
        addOneCVMRequest: VFGRequest?,
        baseUrl: String = "",
        keyChainPrefix: String = "com.ProductsAuthentication.keyChainPrefix.default",
        authorizationObj: Authentication? = nil
        ) {
        self.myAddOnsRequest = myAddOnsRequest
        self.allAddOnsRequest = allAddOnsRequest
        self.addOneCVMRequest = addOneCVMRequest
        addOnDataProvider = VFGNetworkClient(baseURL: baseUrl)
        guard authorizationObj != nil else { return }
        let authObj = ProductsAuthentication(keyChainPrefix: keyChainPrefix, baseUrl: baseUrl)
        if !authObj.isAuthenticated() {
            ProductsAuthentication().signInRequested(authenticationObject: authorizationObj) { error in
                VFGDebugLog(error?.localizedDescription ?? "")
            }
        }
        addOnDataProvider?.authClientProvider = ProductsAuthentication()
    }

    public func fetchMyProducts(completion: ((AddOnsProductsProtocol?, Error?) -> Void)?) {
        guard let request = myAddOnsRequest else {
            completion?(nil, nil)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.addOnDataProvider?.executeData(
                request: request,
                model: AddOnsDXLProducts.self,
                progressClosure: nil) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let model):
                    self.myProducts = model.addOns ?? []
                    completion?(model, nil)
                case .failure(let error):
                    completion?(nil, error)
                }
            }
        }
    }

    public func fetchAllProducts(completion: ((AddOnsProductsProtocol?, Error?) -> Void)?) {
        guard let request = allAddOnsRequest else {
            completion?(nil, nil)
            return
        }
        addOnDataProvider?.executeData(
            request: request,
            model: AllAddOnsDXLProducts.self,
            progressClosure: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.allProducts = model.addOns ?? []
                completion?(model, nil)
            case .failure(let error):
                self.allProducts = []
                completion?(nil, error)
            }
        }
    }
}

// MARK: - manageAddOn provider protocol
extension AddOnsDataProvider: VFGManageAddOnDataProviderProtocol {
    public func updateAddOnDetails(addOn: AddOnsProductModel, completion: @escaping ManageAddOnCompletion) {
        DispatchQueue.global().async { [weak self] in
            if let requiredAddOnIndex = self?.myProducts.firstIndex(where: {
                $0.identifier == addOn.identifier
            }) {
                self?.myProducts[requiredAddOnIndex] = addOn
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }

    public func removeAddOn(addOnId: String, completion: @escaping ManageAddOnCompletion) {
        DispatchQueue.global().async { [weak self] in
            if let requiredAddOnIndex = self?.myProducts.firstIndex(where: {
                $0.identifier == addOnId
            }) {
                self?.myProducts.remove(at: requiredAddOnIndex)
                guard let myProducts = self?.myProducts else { return }
                self?.manageProductsDelegate?.updateProducts(myProducts)
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    public func buyAddOn(addOnId: String, completion: @escaping ManageAddOnCompletion) {
        guard allProducts.isEmpty else {
            buyAddOnLogic(addOnId: addOnId, completion: completion)
            return
        }
        fetchAllProducts { [weak self] model, error in
            guard let self = self else { return }
            guard let model = model else {
                self.allProducts = []
                completion(error)
                return
            }
            self.allProducts = model.addOns ?? []
            self.buyAddOnLogic(addOnId: addOnId, error: error, completion: completion)
        }
    }

    func buyAddOnLogic(addOnId: String, error: Error? = nil, completion: @escaping ManageAddOnCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if let requiredAddOnIndex = self.allProducts.firstIndex(where: {
                $0.identifier == addOnId
            }) {
                self.myProducts.append(self.allProducts[requiredAddOnIndex])
                self.manageProductsDelegate?.updateProducts(self.myProducts)
            }
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
}

// MARK: - CVM addon
extension AddOnsDataProvider: AddOnsCVMDataProviderProtocol {
    public func fetchAddOnsCVM(completion: FetchAddOnsCVMCompletion) {
        guard let request = addOneCVMRequest else {
            completion?(nil, nil)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.addOnDataProvider?.executeData(
                request: request,
                model: AddOnsCVMModel.self,
                progressClosure: nil) { result in
                switch result {
                case .success(let model):
                    completion?(model, nil)
                case .failure(let error):
                    completion?(nil, error)
                }
            }
        }
    }
}
