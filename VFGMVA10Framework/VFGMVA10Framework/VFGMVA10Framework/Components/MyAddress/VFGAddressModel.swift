//
//  VFGAddressModel.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 1/3/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// Saved Address Model 
public struct VFGAddressModel {
    public var postcode: String
    public var houseNumber: String
    public var streetName: String
    public var city: String
    public var country: String

    public init (
        postcode: String,
        houseNumber: String,
        streetName: String,
        city: String,
        country: String
    ) {
        self.postcode = postcode
        self.houseNumber = houseNumber
        self.streetName = streetName
        self.city = city
        self.country = country
    }
}
