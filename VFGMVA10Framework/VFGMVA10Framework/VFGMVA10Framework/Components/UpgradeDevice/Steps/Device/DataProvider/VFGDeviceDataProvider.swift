//
//  VFGDeviceDataProvider.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 18/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public class VFGDeviceDataProvider: VFGDeviceDataProviderProtocol {
    private let networkClient: VFGNetworkClient
    public var bundle = Bundle.mva10Framework
    var delay: Double = 0

    public init(baseURL: String = "") {
        networkClient = VFGNetworkClient(baseURL: baseURL)
    }

    public func fetchDevice(
        fileName: String, completion: VFGDeviceCompletion
    ) {
        let request = VFGRequest(path: getPath(fileName: fileName, bundle: bundle))

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.networkClient.executeData(
                request: request,
                model: VFGDeviceModel.self,
                progressClosure: nil
            ) { result in
                switch result {
                case .success(let model):
                    completion?(model.devices, model.collectionAndDelivery, nil)
                case .failure(let error):
                    completion?(nil, nil, error)
                }
            }
        }
    }

    private func getPath(fileName: String, bundle: Bundle) -> String {
        return bundle.url(
            forResource: fileName,
            withExtension: "json")?.absoluteString ?? ""
    }
}
