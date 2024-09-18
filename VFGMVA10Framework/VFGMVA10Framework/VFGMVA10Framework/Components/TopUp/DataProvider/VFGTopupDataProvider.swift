//
//  VFGTopupDataProvider.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 1/17/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// TopUp data provider.
public class VFGTopUpDataProvider: VFGTopUpDataProviderProtocol {
    private let networkClient: VFGNetworkClientProtocol? = VFGNetworkClient(baseURL: "")
    var fileName: String
    var topUpRequest: VFGRequest?
    public init(fileName: String? = nil, request: VFGRequest? = nil) {
        self.fileName = fileName ?? "topUp_stub"
        topUpRequest = request ?? defaultRequest()
    }

    func defaultRequest() -> VFGRequest? {
        guard let path = Bundle.main.url(forResource: fileName, withExtension: "json")?.absoluteString else {
            return nil
        }
        return VFGRequest(path: path)
    }

    public func fetchDashboardCardData(completion: @escaping (VFGDashboardTopUpModelProtocol?, Error?) -> Void) {
        guard let request = topUpRequest else {
            completion(nil, nil)
            return
        }

        networkClient?.executeData(
            request: request,
            model: VFGDashboardTopUpModel.self,
            progressClosure: nil
        ) { result in
            switch result {
            case .success(let model):
                completion(model, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
