//
//  KeyedDecoderContainer+DictionaryAny.swift
//  VFGMVA10Framework
//
//  Created by Hussien Gamal Mohammed on 11/23/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
public extension KeyedDecodingContainer {
    /// Decodes the given Dictionary type by it's key.
    /// - Parameters:
    ///   - type: Type of the dictionary that would be decoded.
    ///   - key: Key of the given type.
    /// - Throws: A *[String: Any]* of the decoded objects or Error if it is nil.
    func decode(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }

    /// Decodes the given Dictionary type if it's key exists in the decoder.
    /// - Parameters:
    ///   - type: Type of the dictionary that would be decoded.
    ///   - key: Key of the given type.
    /// - Throws: A *[String: Any]* of the decoded objects or Error if it is nil.
    func decodeIfPresent(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any]? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    /// Decodes the given Array type by it's key.
    /// - Parameters:
    ///   - type: Type of the array that would be decoded.
    ///   - key: Key of the given type.
    /// - Throws: A *[Any]* of the decoded objects or Error if it is nil.
    func decode(_ type: [Any].Type, forKey key: K) throws -> [Any] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    /// Decodes the given Array type if it's key exists in the decoder.
    /// - Parameters:
    ///   - type: Type of the array that would be decoded.
    ///   - key: Key of the given type.
    /// - Throws: A *[ Any]?* of the decoded objects or Error if it is nil.
    func decodeIfPresent(_ type: [Any].Type, forKey key: K) throws -> [Any]? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    /// Decodes the given Dictionary type.
    /// - Parameters:
    ///   - type: Type of the dictionary that would be decoded.
    /// - Throws: A *[String: Any]* of the decoded objects or Error if it is nil.
    func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary: [String: Any] = [:]
        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}
