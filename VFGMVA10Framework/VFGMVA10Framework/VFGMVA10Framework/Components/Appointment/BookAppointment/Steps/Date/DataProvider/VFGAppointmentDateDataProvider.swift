//
//  VFGAppointmentDateDataProvider.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/11/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

public class VFGAppointmentDateDataProvider: VFGAppointmentDateDataProviderProtocol {
    private let networkClient: VFGNetworkClient
    var fileName = "appointments_available_slots"
    var bundle = Bundle.mva10Framework
    var delay: Double = 3

    public init(baseURL: String = "") {
        networkClient = VFGNetworkClient(baseURL: baseURL)
    }

    public func fetchAvailableTimeSlots(completion: @escaping (([VFGAppointmentDateModel.AvailableSlot]?, Error?) -> Void)) {
        let request = VFGRequest(path: getPath(fileName: fileName, bundle: bundle))

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.networkClient.executeData(
                request: request,
                model: VFGAppointmentDateModel.self,
                progressClosure: nil
            ) { result in
                switch result {
                case .success(let model):
                    completion(model.availableSlots, nil)
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
