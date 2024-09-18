//
//  VFGUpgradeModel.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 23/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public struct VFGUpgradeModel: VFGUpgradeModelProtocol {
    public var chooseDevice: ChooseDeviceModel.Device?
    public var deviceDetails: ChooseDeviceModel.Device?
    public var collectionAndDelivery: [VFGDeviceModel.CollectionAndDelivery]?
    public var planModel: VFGUpgradePlanModel.Plan?
}
