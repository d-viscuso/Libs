//
//  VFGAppointmentModelProtocol.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/6/21.
//

import Foundation

/// Appointment model protocol.
public protocol VFGAppointmentModelProtocol {
    /// The identifier of the appointment.
    var id: String? { get }
    /// Chosen date for the appointment.
    var dateTime: VFGAppointmentModel.DateTime? { get }
    /// Chosen store for the appointment.
    var store: VFGAppointmentStoreModel.Store? { get }
    /// Chosen service for the appointment.
    var service: VFGAppointmentServiceModel.Service? { get }
    ///  appointment has review or not
    var hasReview: Bool? { get }
    var appointmentFilterationDate: Double? { get }
    /// Requirements for the appointment.
    var requirements: [String]? { get }
}

public extension VFGAppointmentModelProtocol {
    var id: String? {
        nil
    }
    var requirements: [String]? {
        nil
    }
}
