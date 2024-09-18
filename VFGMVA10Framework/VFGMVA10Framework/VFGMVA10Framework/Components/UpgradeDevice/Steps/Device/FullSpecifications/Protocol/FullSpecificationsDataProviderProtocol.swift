//
//  FullSpecificationsDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ashraf Dewan on 19/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

public protocol FullSpecificationsDataProviderProtocol: AnyObject {
    func fetchDevices(
        fileName: String,
        deviceName: String,
        completion: @escaping (([ChooseDeviceModel.Device.Specifications.FullSpec]?, Error?) -> Void)
    )
}
