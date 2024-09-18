//
//  CurrentDeviceDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 10/11/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
public typealias FetchDeviceCompletion = ((CurrentDeviceModelProtocol?, Error?) -> Void)?

/// Current device data provider protocol.
public protocol CurrentDeviceDataProviderProtocol {
    /// Method to fetch current device details.
    /// - Parameters:
    ///     - completion: FetchDeviceCompletion is a typealias for *((CurrentDeviceModelProtocol?, Error?) -> Void)?*.
    func fetchDeviceDetails(completion: FetchDeviceCompletion)
}
