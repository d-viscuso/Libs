//
//  Array+Optionals.swift
//  VFGMVA10Billing
//
//  Created by Mohamed Abd ElNasser on 5/18/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

extension Array {
    /// Checks on the provided element if it is not nil to append it to the array.
    /// If the element is nil it will not be added to the array.
    /// - Parameters:
    ///    - newElement: The item that would be checked on.
    public mutating func appendIfNotNil(_ newElement: Element?) {
        if let element = newElement {
            append(element)
        }
    }

    /// Removes element at the provided index if the element exists in the array, and returns the removed element.
    /// - Parameters:
    ///    - index: Index of the removable element.
    /// - Returns: The removed element if it existed and nil if not.
    public mutating func removeIfExist(at index: Int) -> Element? {
        guard !isEmpty && (0..<count).contains(index) else { return nil }
        return remove(at: index)
    }

    /// Inserts the provided element at the given index if the element not nil.
    /// - Parameters:
    ///    - element: The element that would be added to the array.
    ///    - index: Index of the provided element in the array.
    public mutating func insertIfNotNil(_ element: Element?, at index: Int) {
        guard let element = element else { return }
        insert(element, at: index)
    }
}
