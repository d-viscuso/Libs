//
//  KeyedEncoderContainer+DictionaryAny.swift
//  VFGMVA10Framework
//
//  Created by Hussien Gamal Mohammed on 11/23/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
public extension KeyedEncodingContainer {
    /// Encodes the given object by the given key.
    /// - Parameters:
    ///   - object: Object that would be encoded.
    ///   - key: Key of the given type.
    /// - Throws: An Error if function could not encode the given object.
    mutating func encode(of object: Any, forKey key: K) throws {
        if let objectAsBool = object as? Bool {
            try encode(objectAsBool, forKey: key)
        }
        if let objectAsString = object as? String {
            try encode(objectAsString, forKey: key)
        }
        if let objectAsDouble = object as? Double {
            try encode(objectAsDouble, forKey: key)
        }
        if let objectAsInt = object as? Int {
            try encode(objectAsInt, forKey: key)
        }
        if let objectAsFloat = object as? Float {
            try encode(objectAsFloat, forKey: key)
        }
        if let objectAsDictionaryOfAny = object as? [String: Any] {
            var nestedItem = nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
            try nestedItem.encode(dictionary: objectAsDictionaryOfAny)
        }

        // To be continued
        if let objectAsArrayOfAny = object as? [Any] {
            var nestedItem = nestedUnkeyedContainer(forKey: key)
            try nestedItem.encode(arrayAny: objectAsArrayOfAny)
        }
    }

    /// Encodes the given dictionary.
    /// - Parameters:
    ///   - dictionary: Dictionary that would be encoded.
    /// - Throws: An Error if function could not encode the given dictionary.
    mutating func encode(dictionary: [String: Any]) throws {
        for (subKey, value) in dictionary {
            guard let codedKey = K.init(stringValue: subKey) else {
                return
            }
            try encode(of: value, forKey: codedKey)
        }
    }
}
