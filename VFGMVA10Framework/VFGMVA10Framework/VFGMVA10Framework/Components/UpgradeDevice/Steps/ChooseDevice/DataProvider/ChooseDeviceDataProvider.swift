//
//  ChooseDeviceDataProvider.swift
//  VFGMVA10Framework
//
//  Created by Moamen Abd Elgawad on 18/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public class ChooseDeviceDataProvider: ChooseDeviceDataProviderProtocol {
    private let networkClient = VFGNetworkClient(baseURL: "")

    public init() {}

    public func fetchDevices(completion: @escaping (([ChooseDeviceModel.Device]?, Error?) -> Void)) {
        let fileName = "chooses_devices"
        let request = VFGRequest(path: getPath(fileName: fileName, bundle: .mva10Framework))

        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.networkClient.executeData(
                request: request,
                model: ChooseDeviceModel.self,
                progressClosure: nil
            ) { result in
                switch result {
                case .success(let model):
                    completion(model.devices, nil)
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
