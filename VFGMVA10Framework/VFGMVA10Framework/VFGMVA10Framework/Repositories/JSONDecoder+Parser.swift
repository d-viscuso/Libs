//
//  Parser.swift
//  mva10
//
//  Created by Sandra Morcos on 12/12/18.
//  Copyright © 2018 vodafone. All rights reserved.
//

import Foundation

extension JSONDecoder {
    /// Convert JSON data to Codable object
    /// - Parameters:
    ///   - json: JSON dictionary
    /// - Returns: Codable object
    static func parseJson<T: Codable>(_ json: [String: Any]) -> T? {
        guard let result = try? JSONDecoder.decode(json, to: T.self) else {
            return nil
        }
        return result
    }
    /// Returns a value of the type you specify, decoded from a JSON object
    /// - Parameters:
    ///   - data: The JSON object to decode
    /// - Returns: A value of the specified type, if the decoder can parse the data
    static func parseData<T: Codable>(_ data: Data) -> T? {
        let decoder = JSONDecoder()
        guard let model = try? decoder.decode(T.self, from: data) else {
            return nil
        }
        return model
    }
    /// Convert JSON data to Codable object
    /// - Parameters:
    ///   - json: JSON dictionary
    ///   - type: Type information
    /// - Returns: Codable object
    /// - Throws: Error if failed
    static func decode<T: Codable>(_ json: [String: Any], to type: T.Type) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        return try decode(data, to: type)
    }
}
