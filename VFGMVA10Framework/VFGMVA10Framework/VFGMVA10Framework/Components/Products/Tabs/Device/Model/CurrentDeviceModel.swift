//
//  CurrentDeviceModel.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 10/7/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// Current device model protocol.
public protocol CurrentDeviceModelProtocol: Codable {
    /// Current device details.
    var deviceDetails: DeviceDetails? { get }
}

extension CurrentDeviceModel: CurrentDeviceModelProtocol {}

/// Current device model.
public struct CurrentDeviceModel: Codable {
    public let deviceDetails: DeviceDetails?
    public enum CodingKeys: String, CodingKey {
        case deviceDetails = "device_details"
    }
    public init(deviceDetails: DeviceDetails?) {
        self.deviceDetails = deviceDetails
    }
}

/// Current device details model.
public struct DeviceDetails: Codable {
    /// Device Owner Details
    public let deviceOwnerDetails: String?
    /// Contract end date.
    public let contractEndDate: String?
    /// Device name.
    public let deviceName: String?
    /// Boolean determines if the device is eligable for upgrade or not.
    public let isEligableForUpgrade: Bool?
    /// Upgrade price.
    public let upgradePrice: String?

    public init(
        deviceOwnerDetails: String?,
        contractEndDate: String?,
        deviceName: String?,
        isEligableForUpgrade: Bool?,
        upgradePrice: String?
    ) {
        self.deviceOwnerDetails = deviceOwnerDetails
        self.contractEndDate = contractEndDate
        self.deviceName = deviceName
        self.isEligableForUpgrade = isEligableForUpgrade
        self.upgradePrice = upgradePrice
    }

    public enum CodingKeys: String, CodingKey {
        case deviceOwnerDetails = "device_owner_details"
        case contractEndDate = "contract_end_date"
        case deviceName = "device_name"
        case isEligableForUpgrade = "is_Eligable_for_upgrade"
        case upgradePrice = "upgrade_price"
    }
}
