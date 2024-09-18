//
//  Collection+Extensions.swift
//  VFGMVA10Foundation
//
//  Created by Abdullah Soylemez on 30.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public extension Optional where Wrapped: Collection {
    /// Checks on if the optional is empty or it is nil.
    var isEmptyOrNil: Bool {
        self?.isEmpty ?? true
    }
}
