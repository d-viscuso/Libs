//
//  CATransaction+Extension.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 22/03/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

extension CATransaction {
    /// A method used to supress actions triggered as a result of property changes to` true` made within this transaction group.
    /// The method is declared with the `rethrows` keyword to indicate that it might throw an error if it’s function parameter throws an error.
    /// - Returns: The same result returned from the given body closure.
    public class func withDisabledActions<T>(_ body: () throws -> T) rethrows -> T {
        defer {
            CATransaction.commit()
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        return try body()
    }
}
