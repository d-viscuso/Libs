//
//  NSLayoutConstraint+Extensions.swift
//  VFGMVA10Foundation
//
//  Created by Amr Koritem on 11/05/2022.
//

import UIKit

extension NSLayoutConstraint {
    /// This method is made to avoid crashing in iOS 12.
    static func changePriority(of constraint: inout NSLayoutConstraint, to newPriority: UILayoutPriority) {
        constraint.isActive = false
        let newConstraint = NSLayoutConstraint(
            item: constraint.firstItem as Any,
            attribute: constraint.firstAttribute,
            relatedBy: constraint.relation,
            toItem: constraint.secondItem,
            attribute: constraint.secondAttribute,
            multiplier: constraint.multiplier,
            constant: constraint.constant)
        newConstraint.priority = newPriority
        constraint = newConstraint
        constraint.isActive = true
    }
}
