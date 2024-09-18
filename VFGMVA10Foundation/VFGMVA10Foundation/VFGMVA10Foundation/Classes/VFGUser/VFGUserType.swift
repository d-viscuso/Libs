//
//  VFGUserType.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 11/10/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// `VFGUserType` is a struct to manage and detect the user type.
public struct VFGUserType: Equatable, Codable {
    /// Raw value of the user type.
    public var rawValue: String

    // Default Types
    /// The default payM user type.
    public static let payM = VFGUserType(rawValue: "payM")
    /// The default payG user type.
    public static let payG = VFGUserType(rawValue: "payG")
    /// The default soho user type.
    public static let soho = VFGUserType(rawValue: "soho")

    /// Creates a new instance with the provided raw value.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    /// Checks for equality.
    public static func == (lhs: VFGUserType, rhs: VFGUserType) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    /// Check for not-equality.
    public static func != (lhs: VFGUserType, rhs: VFGUserType) -> Bool {
        lhs.rawValue != rhs.rawValue
    }

    /// Creates a new instance by decoding the provided decoder.
    public init(from decoder: Decoder) throws {
        self = try VFGUserType(rawValue: decoder.singleValueContainer().decode(String.self))
    }

    /// Encodes the raw value into the provided encoder.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
