//
//  VFGAppointmentModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/9/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

/// Appointment model.
public struct VFGAppointmentModel: VFGAppointmentModelProtocol {
    public var dateTime: DateTime?
    public var store: VFGAppointmentStoreModel.Store?
    public var service: VFGAppointmentServiceModel.Service?
    public var hasReview: Bool?
    public var appointmentFilterationDate: Double?

    public init(
        dateTime: VFGAppointmentModel.DateTime? = nil,
        store: VFGAppointmentStoreModel.Store? = nil,
        service: VFGAppointmentServiceModel.Service? = nil,
        hasReview: Bool? = nil,
        appointmentFilterationDate: Double? = nil
    ) {
        self.dateTime = dateTime
        self.store = store
        self.service = service
        self.hasReview = hasReview
        self.appointmentFilterationDate = appointmentFilterationDate
    }

    /// Date time model.
    public struct DateTime: Codable {
        /// Date
        public var date: Date
        /// Chosen time slot for the appointment.
        public var timeSlot: VFGAppointmentDateModel.TimeSlot

        /// Start date, computed property from *timeSlot*.
        var startDate: Date? {
            let dateTimeAsString = VFGDateHelper.getStringFromDate(
                date: date,
                format: "EEEE, dd MMMM, yyyy:"
            ) + timeSlot.time.from

            guard let date = VFGDateHelper.getDateFromString(
                dateString: dateTimeAsString,
                format: "EEEE, dd MMMM, yyyy:ha"
            ) else {
                return nil
            }

            return date
        }

        /// End date, computed property from *timeSlot*.
        var endDate: Date? {
            let dateTimeAsString = VFGDateHelper.getStringFromDate(date: date, format: "EEEE, dd MMMM, yyyy:") + timeSlot.time.to

            guard let date = VFGDateHelper.getDateFromString(
                dateString: dateTimeAsString,
                format: "EEEE, dd MMMM, yyyy:ha"
            ) else {
                return nil
            }

            return date
        }

        public init(date: Date, timeSlot: VFGAppointmentDateModel.TimeSlot) {
            self.date = date
            self.timeSlot = timeSlot
        }
    }
}
