//
//  FullSpecificationsDataProvider.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 19/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public class FullSpecificationsDataProvider: FullSpecificationsDataProviderProtocol {
    private let networkClient = VFGNetworkClient(baseURL: "")

    public init() {}

    public func fetchDevices(
        fileName: String,
        deviceName: String,
        completion: @escaping (([ChooseDeviceModel.Device.Specifications.FullSpec]?, Error?
        ) -> Void)
    ) {
        let request = VFGRequest(path: getPath(fileName: fileName, bundle: .mva10Framework))

        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.networkClient.executeData(
                request: request,
                model: ChooseDeviceModel.self,
                progressClosure: nil
            ) { result in
                switch result {
                case .success(let model):
                    guard let devices = model.devices else { return }
                    devices.forEach { device in
                        if device.id == deviceName {
                            completion(device.specifications?.fullSpecs, nil)
                        }
                    }
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
