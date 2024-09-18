//
//  FreshConstraint.swift
//  ewdewfd
//
//  Created by Claudio Cavalli on 18/05/22.
//

import Foundation
import UIKit

// MARK: - FreshConstraint.
public struct FreshConstraint {
    // item is the view that use this constraint.
    public let item: UIView
    // attribute of constraint.
    public let attribute: NSLayoutConstraint.Attribute
    // multiplier of constraint.
    public let multiplier: CGFloat
    // constant of constraint.
    public let constant: CGFloat
    
    // create contraint relative to a second View.
    public func constrain(_ secondItem: FreshConstraint, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relation, toItem: secondItem.item, attribute: secondItem.attribute, multiplier: secondItem.multiplier, constant: secondItem.constant)
    }
    
    // create contraint with a constant.
    public func constrain(_ constant: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant)
    }
    
    // create FreshConstraint with a multiplier.
    public func multiplier(_ multiplier: CGFloat) -> FreshConstraint {
        FreshConstraint(item: self.item, attribute: self.attribute, multiplier: multiplier, constant: self.constant)
    }
    
    // create FreshConstraint with a constant.
    public func constant(_ constant: CGFloat) -> FreshConstraint {
        FreshConstraint(item: self.item, attribute: self.attribute, multiplier: self.multiplier, constant: constant)
    }
}
