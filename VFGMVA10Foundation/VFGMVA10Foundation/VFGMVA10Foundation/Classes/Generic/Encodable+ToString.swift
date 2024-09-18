//
//  Encodable+ToString.swift
//  VFGMVA10Foundation
//
//  Created by Tomasz Czyżak on 19/06/2019.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

public extension Encodable {
    /// Returns an optional String object of current object that confirms to **Encodable** protocol.
    /// - Returns: A *String?* object of current Encodable object.
    func toString() -> String? {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
}
