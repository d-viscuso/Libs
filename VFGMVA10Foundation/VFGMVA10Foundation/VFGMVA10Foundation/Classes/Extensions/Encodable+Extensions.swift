//
//  Encodable+Extensions.swift
//  VFGMVA10Foundation
//
//  Created by Abdullah Soylemez on 30.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public extension Encodable {
    /// Creates a Dictionary of the encoded elements.
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (
            try? JSONSerialization.jsonObject(
                with: data,
                options: .allowFragments
            )
        ).flatMap { $0 as? [String: Any] }
    }

    /// Creates a VFGParameters of the encoded elements.
    var vfgParameters: VFGParameters? {
        guard let dictionary = dictionary else { return nil }
        return dictionary.map { ($0.key, $0.value) }
    }
}
