//
//  VFGAppointmentStoreModel.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/11/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// A struct model which represents a specific location details.
public struct VFGLocation {
    public let name, address, details, openingTime: String
    public let status, ctaTitle: String
    public let coordinate: Coordinate

    /// `VFGLocation` struct initializer.
    /// - Parameters:
    ///   - name: A string object which represents location name.
    ///   - address: A string object which represents location address.
    ///   - details: A string object which represents location details.
    ///   - openingTime: A string object which represents location opening time.
    ///   - status: A string object which represents location status.
    ///   - ctaTitle: A string object which represents location button title.
    ///   - coordinate: An object of type *Coordinate* which represents location coordinates.
    public init(
        name: String,
        address: String,
        details: String,
        openingTime: String,
        status: String,
        ctaTitle: String,
        coordinate: Coordinate
    ) {
        self.name = name
        self.address = address
        self.details = details
        self.openingTime = openingTime
        self.status = status
        self.ctaTitle = ctaTitle
        self.coordinate = coordinate
    }
}

/// A struct model which represents the coordinates of a location including latitude and longitude.
public struct Coordinate {
    public let latitude, longitude: Double

    /// `Coordinate` struct initializer.
    /// - Parameters:
    ///   - latitude: A double object which represents location latitude.
    ///   - longitude: A double object which represents location longitude.
    public init(
        latitude: Double,
        longitude: Double
    ) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
