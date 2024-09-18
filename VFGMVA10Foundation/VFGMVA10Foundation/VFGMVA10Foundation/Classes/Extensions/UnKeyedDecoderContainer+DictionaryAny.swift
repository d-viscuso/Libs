//
//  UnKeyedDecoderContainer+DictionaryAny.swift
//  VFGMVA10Framework
//
//  Created by Hussien Gamal Mohammed on 11/23/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

public extension UnkeyedDecodingContainer {
    /// Decodes a value of the given array type.
    /// - Parameters:
    ///   - type: Type of the array that would be decoded.
    /// - Throws: A *[Any]* of the decoded objects or Error if it is nil.
    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []
        while isAtEnd == false {
            // See if the current value in the JSON array is `null` first and prevent
            // infite recursion with nested arrays.
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode(Array<Any>.self) {
                array.append(nestedArray)
            }
        }
        return array
    }

    /// Decodes a value of the given dictionary type.
    /// - Parameters:
    ///   - type: Type of the dictionary that would be decoded.
    /// - Throws: A *[String: Any]* of the decoded objects or Error if it is nil.
    mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}
