//
//  VFGAddPlanDataProvider.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 7/5/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import VFGMVA10Foundation

/// Add plan data provider.
public class VFGAddPlanDataProvider {
    /// Network client.
    public let addPlanNetworkClient: VFGNetworkClientProtocol? = VFGNetworkClient(baseURL: "")
    /// Add plan model.
    public var addPlanModel: VFGAddPlanModelProtocol?
    public init() {}
}
