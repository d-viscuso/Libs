//
//  Decodable+Init.swift
//  VFGMVA10Foundation
//
//  Created by Tomasz Czyżak on 19/06/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

public extension Decodable {
    /// Creates new instance by decoding the given JSON String.
    /// - Parameters:
    ///    - JSONString: JSON String that would be decoded.
    init?(JSONString: String?) {
        guard let json = JSONString,
            let jsonData = json.data(using: .utf8),
            let anInstance = try? JSONDecoder().decode(Self.self, from: jsonData) else {
                return nil
        }
        self = anInstance
    }
}
