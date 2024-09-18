//
//  DeviceViewModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 10/7/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//
import Foundation
/// Device view model.
public class DeviceViewModel: DeviceViewModelProtocol {
    /// Current device data provider.
    public var currentDeviceDataProvider: CurrentDeviceDataProviderProtocol
    public var deviceDetails: DeviceDetails?

    public var updateLoadingStatus: (() -> Void)?
    public var contentState: VFGContentState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    public init(currentDeviceDataProvider: CurrentDeviceDataProviderProtocol) {
        self.currentDeviceDataProvider = currentDeviceDataProvider
    }

    public func fetchDeviceDetails() {
        contentState = .loading
        currentDeviceDataProvider.fetchDeviceDetails { [weak self] model, error in
            guard let self = self else { return }
            if error != nil {
                self.contentState = .error
                return
            }
            guard let deviceDetails = model?.deviceDetails else {
                self.contentState = .error
                return
            }
            self.deviceDetails = deviceDetails
            self.contentState = .populated
        }
    }
}
