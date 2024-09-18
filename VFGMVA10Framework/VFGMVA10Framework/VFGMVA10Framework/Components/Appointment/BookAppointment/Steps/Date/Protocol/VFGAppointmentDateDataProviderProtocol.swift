//
//  VFGAppointmentDateDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/14/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// Appointment date data provider protocol.
public protocol VFGAppointmentDateDataProviderProtocol: AnyObject {
    /// Method to fetch available time slots.
    /// - Parameters:
    ///     - completion: *([VFGAppointmentDateModel.AvailableSlot]?, Error?)* completion of available time slots in each day for current week for the chosen store  in case of success & error in case of failure.
    func fetchAvailableTimeSlots(completion: @escaping (([VFGAppointmentDateModel.AvailableSlot]?, Error?) -> Void))
}
