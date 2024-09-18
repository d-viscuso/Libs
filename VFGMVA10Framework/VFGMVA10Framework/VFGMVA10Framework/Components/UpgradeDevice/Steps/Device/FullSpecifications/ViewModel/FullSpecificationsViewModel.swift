//
//  FullSpecificationsViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 19/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class FullSpecificationsViewModel {
    private let dataProvider: FullSpecificationsDataProviderProtocol
    private var fullSpecs: [ChooseDeviceModel.Device.Specifications.FullSpec] = []
    var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var updateLoadingStatus: (() -> Void)?

    init(
        dataProvider: FullSpecificationsDataProviderProtocol = FullSpecificationsDataProvider()
    ) {
        self.dataProvider = dataProvider
    }

    func fetchFullSpecs(from fileName: String?, with selectedDevice: String?) {
        guard let fileName = fileName else { return }
        guard let selectedDevice = selectedDevice else { return }
        contentState = .loading
        dataProvider.fetchDevices(fileName: fileName, deviceName: selectedDevice) { [weak self] fullSpecs, _ in
            guard
                let self = self,
                let fullSpecs = fullSpecs else {
                return
            }

            self.fullSpecs = fullSpecs
            self.contentState = .populated
        }
    }

    func numberOfFullSpecs() -> Int {
        fullSpecs.count
    }

    func numberOfItems(in section: Int) -> Int {
        fullSpecs[section].items?.count ?? 0
    }

    func getSpecTitle(in section: Int) -> String {
        fullSpecs[section].title ?? ""
    }

    func getSpecItems(in section: Int) -> [String] {
        fullSpecs[section].items ?? []
    }
}
