//
//  VFGAppointmentStoreDataProvider.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/11/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public class VFGAppointmentStoreDataProvider: VFGAppointmentStoreDataProviderProtocol {
    private let networkClient: VFGNetworkClient

    public init(baseURL: String = "") {
        networkClient = VFGNetworkClient(baseURL: baseURL)
    }

    public func fetchStores(completion: @escaping (([VFGAppointmentStoreModel.Store]?, Error?) -> Void)) {
        let fileName = "stores"
        let request = VFGRequest(path: getPath(fileName: fileName, bundle: .mva10Framework))

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.networkClient.executeData(
                request: request,
                model: VFGAppointmentStoreModel.self,
                progressClosure: nil
            ) { result in
                switch result {
                case .success(let model):
                    completion(model.stores, nil)
                case .failure(let error):
                    completion(nil, error)
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
