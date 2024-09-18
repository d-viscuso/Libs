//
//  ChooseDeviceViewModel.swift
//  VFGMVA10Framework
//
//  Created by Moamen Abd Elgawad on 18/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class ChooseDeviceViewModel {
    private let dataProvider: ChooseDeviceDataProviderProtocol
    private var devices: [ChooseDeviceModel.Device] = []
    var selectedDevice: ChooseDeviceModel.Device?
    var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var updateLoadingStatus: (() -> Void)?

    init(dataProvider: ChooseDeviceDataProviderProtocol = ChooseDeviceDataProvider()) {
        self.dataProvider = dataProvider
    }

    func fetchDevices() {
        contentState = .loading
        dataProvider.fetchDevices { [weak self] devices, _ in
            guard
                let self = self,
                let devices = devices else {
                return
            }

            self.devices = devices
            self.contentState = .populated
        }
    }

    func numberOfDevices() -> Int {
        devices.count
    }

    func device(at index: Int) -> ChooseDeviceModel.Device {
        devices[index]
    }

    func swapSelectedDeviceWithDevice(at index: Int) {
        devices.swapAt(0, index)
        selectedDevice = devices.first
    }

    func isSelectedDeviceEqualDevice(at index: Int) -> Bool {
        selectedDevice == device(at: index)
    }

    func isDeviceSelected(_ index: Int) -> Bool {
        device(at: index) == selectedDevice
    }
}
