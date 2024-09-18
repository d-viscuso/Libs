//
//  VFGAppointmentServiceViewModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/9/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGAppointmentServiceViewModel {
    private let dataProvider: VFGAppointmentServiceDataProviderProtocol
    private var services: [VFGAppointmentServiceModel.Service] = []
    var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var updateLoadingStatus: (() -> Void)?

    init(dataProvider: VFGAppointmentServiceDataProviderProtocol = VFGAppointmentServiceDataProvider()) {
        self.dataProvider = dataProvider
    }

    func fetchServices() {
        contentState = .loading
        dataProvider.fetchServices { [weak self] services, _ in
            guard
                let self = self,
                let services = services else {
                return
            }

            self.services = services
            self.contentState = .populated
        }
    }

    func numberOfServices() -> Int {
        services.count
    }

    func service(at index: Int) -> VFGAppointmentServiceModel.Service {
        services[index]
    }
}
