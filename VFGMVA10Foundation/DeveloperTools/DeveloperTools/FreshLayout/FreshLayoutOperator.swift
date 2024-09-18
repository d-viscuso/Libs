//
//  FreshLayoutDSL.swift
//  ewdewfd
//
//  Created by Claudio Cavalli on 18/05/22.
//

import Foundation
import UIKit

// MARK: - FreshConstraint Operator Overloading.
// create a FreshConstraint with multipler *.
public func *(lhs: FreshConstraint, rhs: CGFloat) -> FreshConstraint {
    lhs.multiplier(lhs.multiplier * rhs)
}

// create a FreshConstraint with multipler /.
public func /(lhs: FreshConstraint, rhs: CGFloat) -> FreshConstraint {
    lhs.multiplier(lhs.multiplier / rhs)
}

// create a FreshConstraint with relative view and add + constant.
public func +(lhs: FreshConstraint, rhs: CGFloat) -> FreshConstraint {
    lhs.constant(lhs.constant + rhs)
}

// create a FreshConstraint with relative view and add - constant.
public func -(lhs: FreshConstraint, rhs: CGFloat) -> FreshConstraint {
    lhs.constant(lhs.constant - rhs)
}

// create a FreshConstraint equalTo second view.
public func ==(lhs: FreshConstraint, rhs: FreshConstraint) -> NSLayoutConstraint {
    lhs.constrain(rhs, relation: .equal)
}

// create a FreshConstraint equalTo constant.
public func ==(lhs: FreshConstraint, rhs: CGFloat) -> NSLayoutConstraint {
    lhs.constrain(rhs, relation: .equal)
}

// create a FreshConstraint greaterThanOrEqual second view.
public func >=(lhs: FreshConstraint, rhs: FreshConstraint) -> NSLayoutConstraint {
    lhs.constrain(rhs, relation: .greaterThanOrEqual)
}

// create a FreshConstraint lessThanOrEqual second view.
public func <=(lhs: FreshConstraint, rhs: FreshConstraint) -> NSLayoutConstraint {
    lhs.constrain(rhs, relation: .lessThanOrEqual)
}
