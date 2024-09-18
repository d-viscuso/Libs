//
//  ActivePlanServicesDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 7/7/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

public typealias FetchActiveServicesCompletion = ((ActivePlanServicesProtocol?, Error?) -> Void)?
/// My plan data provider protocol.
public protocol MyPlanDataProviderProtocol {
    /// Method that fetch active services
    /// - Parameters:
    ///     - completion: FetchActiveServicesCompletion is a typealias for *((ActivePlanServicesProtocol?, Error?) -> Void)?*.
    func fetchActiveServices(completion: FetchActiveServicesCompletion)
    /// Method returns a custom details view for a specific index.
    func customDetailsView(at index: Int) -> UIView?
}

public extension MyPlanDataProviderProtocol {
    func customDetailsView(at index: Int) -> UIView? { nil }
}
