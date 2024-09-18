//
//  VFGAppointmentServiceDataProvider.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/11/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public class VFGAppointmentServiceDataProvider: VFGAppointmentServiceDataProviderProtocol {
    private let networkClient = VFGNetworkClient(baseURL: "")

    public init() {}

    public func fetchServices(completion: @escaping (([VFGAppointmentServiceModel.Service]?, Error?) -> Void)) {
        let fileName = "appointments_services"
        let request = VFGRequest(path: getPath(fileName: fileName, bundle: .mva10Framework))

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.networkClient.executeData(
                request: request,
                model: VFGAppointmentServiceModel.self,
                progressClosure: nil
            ) { result in
                switch result {
                case .success(let model):
                    completion(model.allServices, nil)
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
