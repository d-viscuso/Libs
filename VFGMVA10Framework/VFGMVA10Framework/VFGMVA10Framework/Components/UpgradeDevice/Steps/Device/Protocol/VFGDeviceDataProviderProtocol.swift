//
//  VFGDeviceDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 20/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public typealias VFGDeviceCompletion = (
    ([ChooseDeviceModel.Device]?, [VFGDeviceModel.CollectionAndDelivery]?, Error?) -> Void)?

/// Devices Fetching Data Protocol.
public protocol VFGDeviceDataProviderProtocol {
    /// Method that is called to fetch devices data.
    ///     - Parameters:
    ///     - fileName:the file name that is used to get Device Model.
    ///     - completion: contains the fetched Device model and collection model or Error if could't fetch model.
    func fetchDevice(fileName: String, completion: VFGDeviceCompletion)
}
