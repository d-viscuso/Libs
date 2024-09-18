//
//  VFGUpgradePlanDataProvider.swift
//  VFGMVA10Framework
//
//  Created by Abdallah Shaheen on 5/19/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public class VFGUpgradePlanDataProvider: VFGUpgradePlanDataProviderProtocol {
    private let networkClient = VFGNetworkClient(baseURL: "")

    public init() {}

    public func fetchPlans(completion: @escaping ((VFGUpgradePlanModel?, Error?) -> Void)) {
        let fileName = "upgrade_plan"
        let request = VFGRequest(path: getPath(fileName: fileName, bundle: .mva10Framework))

        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.networkClient.executeData(
                request: request,
                model: VFGUpgradePlanModel.self,
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


    private func getPath(fileName: String, bundle: Bundle) -> String {
        return bundle.url(
            forResource: fileName,
            withExtension: "json")?.absoluteString ?? ""
    }
}
