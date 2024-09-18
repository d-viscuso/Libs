//
//  VFGAppointmentStoreViewModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/11/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import MapKit

class VFGAppointmentStoreViewModel {
    private let dataProvider: VFGAppointmentStoreDataProviderProtocol
    private(set) var stores: [VFGAppointmentStoreModel.Store] = []

    var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var updateLoadingStatus: (() -> Void)?

    init(dataProvider: VFGAppointmentStoreDataProviderProtocol = VFGAppointmentStoreDataProvider(baseURL: "")) {
        self.dataProvider = dataProvider
    }

    func fetchStores() {
        contentState = .loading
        dataProvider.fetchStores { [weak self] stores, _ in
            guard
                let self = self,
                let stores = stores else {
                return
            }

            self.stores = stores
            self.contentState = .populated
        }
    }

    func numberOfStores() -> Int {
        stores.count
    }

    func store(at index: Int) -> VFGAppointmentStoreModel.Store? {
        guard index < stores.count else {
            return nil
        }

        return stores[index]
    }
}
