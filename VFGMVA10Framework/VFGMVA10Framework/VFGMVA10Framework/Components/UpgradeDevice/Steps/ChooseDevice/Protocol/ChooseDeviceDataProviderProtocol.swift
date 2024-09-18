//
//  ChooseDeviceDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Moamen Abd Elgawad on 18/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// Choose Device Fetch Data Protocol.
public protocol ChooseDeviceDataProviderProtocol: AnyObject {
    /// Method that is called to fetch device data.
    ///     - Parameters:
    ///     - completion: contains the fetched Device model or Error if could't fetch model.
    func fetchDevices(completion: @escaping (([ChooseDeviceModel.Device]?, Error?) -> Void))
}
