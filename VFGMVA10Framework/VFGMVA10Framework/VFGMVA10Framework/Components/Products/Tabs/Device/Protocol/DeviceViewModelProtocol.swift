//
//  DeviceViewModel.swift
//  VFGMVA10Framework
//
//  Created by SAMEH on 14/03/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Device view model protocol.
public protocol DeviceViewModelProtocol {
    /// Completion called when view starts loading.
    var updateLoadingStatus: (() -> Void)? { get set }
    /// Content state *empty, loading, etc*.
    var contentState: VFGContentState { get }
    /// Device details model.
    var deviceDetails: DeviceDetails? { get }
    /// Method to fetch device details.
    func fetchDeviceDetails()
}
