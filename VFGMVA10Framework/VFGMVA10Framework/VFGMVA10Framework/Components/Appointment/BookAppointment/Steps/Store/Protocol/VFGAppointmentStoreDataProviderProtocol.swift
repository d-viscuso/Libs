//
//  VFGAppointmentStoreDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/11/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// Appointment store data provider protocol.
public protocol VFGAppointmentStoreDataProviderProtocol: AnyObject {
    /// Method to fetch available stores.
    /// - Parameters:
    ///     - completion: *([VFGAppointmentStoreModel.Store]?, Error?)* completion of array of stores in case of success & error in case of failure.
    func fetchStores(completion: @escaping (([VFGAppointmentStoreModel.Store]?, Error?) -> Void))
}
