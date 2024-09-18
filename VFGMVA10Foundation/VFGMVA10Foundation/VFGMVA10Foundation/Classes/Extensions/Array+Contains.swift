//
//  Array+Contains.swift
//  VFGMVA10Foundation
//
//  Created by Erdem ILDIZ on 26.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public extension Array {
    /// Safely checks on the given index if it is in the array bounds, and return the potential element.
    ///
    ///
    /// Use this function if you are not sure about the index if it exists in the array bounds or not.
    ///
    /// Note that the function will return optional value, if the element exists it will return it as optional and if not it will return nil.
    /// - Parameters:
    ///    - index: Index of the wanted element.
    /// - Returns: A *Element?* at the given index.
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
