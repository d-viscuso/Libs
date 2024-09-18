//
//  Comparable.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 3/29/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

public func clamp<T: Comparable>(value: T, min: T, max: T) -> T {
    return Swift.max(min, Swift.min(max, value))
}
