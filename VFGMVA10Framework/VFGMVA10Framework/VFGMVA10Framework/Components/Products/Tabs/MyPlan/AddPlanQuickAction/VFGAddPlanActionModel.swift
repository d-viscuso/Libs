//
//  VFGAddPlanActionModel.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 7/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// Add plan model protocol.
public protocol VFGAddPlanModelProtocol {
    /// List of data bundles that user will choose from to add a plan.
    var dataBundles: [VFGDataBundle]? { get }
    /// Currency.
    var currency: String? { get }
    /// Service type.
    var serviceType: String? { get }
}
extension VFGAddPlanModel: VFGAddPlanModelProtocol {}

/// Add plan model.
public struct VFGAddPlanModel: Codable {
    public let dataBundles: [VFGDataBundle]?
    public var currency: String?
    public var serviceType: String?
    public init (
        dataBundles: [VFGDataBundle]?,
        currency: String?,
        serviceType: String?
    ) {
        self.dataBundles = dataBundles
        self.currency = currency
        self.serviceType = serviceType
    }
    enum CodingKeys: String, CodingKey {
        case dataBundles = "data_bundles"
        case serviceType = "service_type"
        case currency
    }
}

/// enum represents the plan type whether it's *data, sms or calls*.
public enum AddPlanType: String {
    case data = "Data"
    case sms = "SMS"
    case calls = "Local calls"
}

/// Data bundle.
public struct VFGDataBundle: Codable, Equatable {
    /// Bundle price.
    public let bundlePrice: Int?
    /// Bundle amount.
    public let bundleAmount: Int?
    /// Data unit.
    public let dataUnit: String?
    public init (bundlePrice: Int?, bundleAmount: Int?, dataUnit: String?) {
        self.bundlePrice = bundlePrice
        self.bundleAmount = bundleAmount
        self.dataUnit = dataUnit
    }
    enum CodingKeys: String, CodingKey {
        case bundlePrice = "bundle_price"
        case bundleAmount = "bundle_amount"
        case dataUnit = "data_unit"
    }
}
