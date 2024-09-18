//
//  VFGAppointmentServiceDataProviderProtocol.swift
//  VFGMVA10FrameworkTests
//
//  Created by Yahya Saddiq on 2/10/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// Appointment service data provider protocol.
public protocol VFGAppointmentServiceDataProviderProtocol: AnyObject {
    /// Method to fetch appointment service.
    /// - Parameters:
    ///     - completion: *([VFGAppointmentServiceModel.Service]?, Error?)* completion of array of appointment service in case of success & error in case of failure.
    func fetchServices(completion: @escaping (([VFGAppointmentServiceModel.Service]?, Error?) -> Void))
}
