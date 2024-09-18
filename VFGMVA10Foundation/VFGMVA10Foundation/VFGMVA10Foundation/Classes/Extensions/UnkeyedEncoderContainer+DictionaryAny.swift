//
//  UnkeyedEncoderContainer+DictionaryAny.swift
//  VFGMVA10Framework
//
//  Created by Hussien Gamal Mohammed on 11/23/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
/// `JSONCodingKeys` is public struct wraps coding keys functionality in a simple interface.
public struct JSONCodingKeys: CodingKey {
    /// String value of the coding key.
    public var stringValue: String

    /// Creates new instance of the JSONCodingKey by the given string.
    /// - Parameters:
    ///    - stringValue: String value of the coding key.
    public init?(stringValue: String) {
        self.stringValue = stringValue
    }

    /// Int value of the coding key.
    public var intValue: Int?

    /// Creates new instance of the JSONCodingKey by the given intger.
    /// - Parameters:
    ///    - intValue: Intger value of the coding key.
    public init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

public extension UnkeyedEncodingContainer {
    /// Encodes the given object to it's right type (eg: Bool, Dictionary<>, Array<>, ... etc)
    /// - Parameters:
    ///    - object: Object that would be encoded.
    mutating func encode(anyObject object: Any) throws {
        if let objectAsBool = object as? Bool {
            try encode(objectAsBool)
        }
        if let objectAsString = object as? String {
            try encode(objectAsString)
        }
        if let objectAsDouble = object as? Double {
            try encode(objectAsDouble)
        }
        if let objectAsInt = object as? Int {
            try encode(objectAsInt)
        }
        if let objectAsFloat = object as? Float {
            try encode(objectAsFloat)
        }
        if let objectAsDictionary = object as? [String: Any] {
            try encode(dictionary: objectAsDictionary)
        }
        if let objectAsArrayAny = object as? [Any] {
            try encode(arrayAny: objectAsArrayAny)
        }
    }

    /// Encodes the given dictionary.
    /// - Parameters:
    ///    - dictionary: Dictionary that would be encoded.
    mutating func encode(dictionary: [String: Any]) throws {
        var nestedContainerObject = nestedContainer(keyedBy: JSONCodingKeys.self)
        try nestedContainerObject.encode(dictionary: dictionary)
    }

    /// Encodes the given array.
    /// - Parameters:
    ///    - arrayAny: Array that would be encoded.
    mutating func encode(arrayAny: [Any]) throws {
        for object in arrayAny {
            try encode(anyObject: object)
        }
    }
}
