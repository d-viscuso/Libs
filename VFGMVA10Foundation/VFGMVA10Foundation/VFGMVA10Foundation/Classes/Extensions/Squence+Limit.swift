//
//  Squence+Limit.swift
//  VFGMVA10Foundation
//
//  Created by Erdem ILDIZ on 26.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public extension Sequence {
    /// Limits the sequence elements to the given max value.
    ///
    /// For example:-
    /// - let firstThreeElements = [1, 2, 3, 4, 5, 6, 7].limit(3)
    /// - firstThreeElements now equals to [1, 2, 3]
    /// - Parameters:
    ///    - max: Value at which above it will be neglected
    /// - Returns: A *Sequence* of elements which indices under the max value.
    func limit(_ max: Int) -> [Element] {
        return self.enumerated()
            .filter { $0.offset < max }
            .map { $0.element }
    }
}
