//
//  VFGGenericJson.swift
//  VFGMVA10Foundation
//
//  Created by Tomasz Czyżak on 16/05/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// `VFGGenericJson` is a public enum to handle (encodes & decodes) the different JSON to generic types.
public enum VFGGenericJson: Codable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case object([String: VFGGenericJson])
    case array([VFGGenericJson])

    /// Encodes current JSON to it's generic type.
    /// - Parameters:
    ///   - encoder: The encoder that can encode values into a native format for external representation.
    /// - Throws: Error if failed.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let string): try container.encode(string)
        case .int(let int): try container.encode(int)
        case .double(let double): try container.encode(double)
        case .bool(let bool): try container.encode(bool)
        case .object(let object): try container.encode(object)
        case .array(let array): try container.encode(array)
        }
    }

    /// Creates new instance depending on the given decoder.
    /// - Parameters:
    ///   - decoder: The decoder that can decode values from a native format into in-memory representations.
    /// - Throws: Error if failed.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode([String: VFGGenericJson].self) {
            self = .object(value)
        } else if let value = try? container.decode([VFGGenericJson].self) {
            self = .array(value)
        } else {
            throw DecodingError.typeMismatch(
                VFGGenericJson.self,
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Not a JSON"
                )
            )
        }
    }
}
