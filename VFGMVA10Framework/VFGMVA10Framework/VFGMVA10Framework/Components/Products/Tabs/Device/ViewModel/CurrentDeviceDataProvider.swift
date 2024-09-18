//
//  CurrentDeviceDataProvider.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 10/11/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class CurrentDeviceDataProvider: CurrentDeviceDataProviderProtocol {
    private var networkClient: VFGNetworkClientProtocol?
    var currentDeviceDetails: CurrentDeviceModelProtocol?
    var deviceRequest: VFGRequest?
    init(
        request: VFGRequest?,
        baseUrl: String = "",
        keyChainPrefix: String = "com.ProductsAuthentication.keyChainPrefix.default",
        authorizationObj: Authentication? = nil
    ) {
        deviceRequest = request
        networkClient = VFGNetworkClient(baseURL: baseUrl)
        if authorizationObj != nil {
            let authObj = ProductsAuthentication(keyChainPrefix: keyChainPrefix, baseUrl: baseUrl)
            if !authObj.isAuthenticated() {
                ProductsAuthentication().signInRequested(authenticationObject: authorizationObj) { error in
                    VFGDebugLog(error?.localizedDescription ?? "")
                }
            }
            networkClient?.authClientProvider = ProductsAuthentication()
        }
    }

    func fetchDeviceDetails(completion: FetchDeviceCompletion) {
        guard let request = deviceRequest else {
            completion?(nil, nil)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else {
                return
            }
            self.networkClient?.executeData(
                request: request,
                model: CurrentDeviceDXLModel.self,
                progressClosure: nil
            ) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let model):
                    self.currentDeviceDetails = model
                    completion?(model, nil)
                case .failure(let error):
                    completion?(nil, error)
                }
            }
        }
    }
}
