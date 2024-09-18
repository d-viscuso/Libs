//
//  VFGStoreAnnotation.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 2/11/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import MapKit

/// A class model which represents a specific location annotation details.
public class VFGLocationAnnotation: NSObject, MKAnnotation {
    public let title: String?
    public let address: String?
    public let info: String?
    public let coordinate: CLLocationCoordinate2D
    public var image: UIImage?
    public let identifier: String?

    /// `VFGLocationAnnotation` class initializer.
    /// - Parameters:
    ///   - id: A string object which represents the location annotation identifier.
    ///   - title: A string object which represents the location annotation title.
    ///   - address: A string object which represents the location annotation address.
    ///   - info: A string object which represents the location annotation details.
    ///   - coordinate: A string object which represents the location annotation coordinates.
    public init(id: String, title: String, address: String, info: String, coordinate: CLLocationCoordinate2D) {
        self.identifier = id
        self.title = title
        self.coordinate = coordinate
        self.address = address
        self.info = info
        super.init()
    }
}

extension CLLocationCoordinate2D: Equatable {
    /// Checks for equality.
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
