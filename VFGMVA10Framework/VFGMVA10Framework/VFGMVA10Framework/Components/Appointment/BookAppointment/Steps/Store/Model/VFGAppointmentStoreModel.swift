//
//  VFGAppointmentStoreModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/11/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

// MARK: - Welcome
/// Appointment store model.
public struct VFGAppointmentStoreModel: Codable {
    /// List of stores.
    public var stores: [Store]?

    public init() {}

    public struct Store: Codable {
        public var id: String?
        public var name, address, details, openingTime: String
        public var email, phoneNumber: String
        /// Coordinate of the store's location.
        public var coordinate: Coordinate

        public init(
            id: String? = nil,
            name: String,
            address: String,
            details: String,
            openingTime: String,
            email: String,
            phoneNumber: String,
            coordinate: VFGAppointmentStoreModel.Coordinate
        ) {
            self.id = id
            self.name = name
            self.address = address
            self.details = details
            self.openingTime = openingTime
            self.email = email
            self.phoneNumber = phoneNumber
            self.coordinate = coordinate
        }
    }

    public struct Coordinate: Codable {
        public var latitude, longitude: Double

        public init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
}
