//
//  VFGUpgradeModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Moustafa Hegazy on 23/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public protocol VFGUpgradeModelProtocol {
    var chooseDevice: ChooseDeviceModel.Device? { get }
    var deviceDetails: ChooseDeviceModel.Device? { get }
    var collectionAndDelivery: [VFGDeviceModel.CollectionAndDelivery]? { get }
    var planModel: VFGUpgradePlanModel.Plan? { get }
}
