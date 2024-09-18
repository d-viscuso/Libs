//
//  VFGAppointmentServiceModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/9/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

/// Appointment service model.
public struct VFGAppointmentServiceModel: Codable {
    /// List of all appointment services available.
    public var allServices: [VFGAppointmentServiceModel.Service]

    public init(allServices: [VFGAppointmentServiceModel.Service]) {
        self.allServices = allServices
    }

    /// Appointment service model.
    public struct Service: Codable {
        /// Service title.
        public var title: String
        /// Service duration.
        public var duration: String
        /// Service details.
        public var details: String
        /// Service icon image name in assets.
        public var iconImageName: String
        /// Summary icon image name in assets.
        public var summaryIconImageName: String

        public init(
            title: String,
            duration: String,
            details: String,
            iconImageName: String,
            summaryIconImageName: String
        ) {
            self.title = title
            self.duration = duration
            self.details = details
            self.iconImageName = iconImageName
            self.summaryIconImageName = summaryIconImageName
        }
    }
}
