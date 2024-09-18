//
//  VFGDeviceModel.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 20/05/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public struct VFGDeviceModel: Codable {
    var devices: [ChooseDeviceModel.Device]?
    var collectionAndDelivery: [CollectionAndDelivery]?

    public init() {}

    public struct CollectionAndDelivery: Codable {
        var id: String?
        var imageUrl: String?
        var title, duration: String?
        var price: Float?
        var currency: String?
    }
}

extension VFGDeviceModel.CollectionAndDelivery: Equatable { }

extension VFGDeviceModel.CollectionAndDelivery {
    var formattedPrice: String? {
        if price == 0 {
            return "device_upgrade_device_step_free".localized(bundle: .mva10Framework)
        }
        guard let price = price, let currency = currency else {
            return nil
        }
        let priceString = price.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", price) : String(price)
        return currency + priceString
    }
}

extension ChooseDeviceModel.Device.Price {
    var formatedUpfrontPrice: String {
        return "+\(upfrontPrice ?? 0)\(currency ?? "")/\(recurrencePeriod ?? "")"
    }
}
