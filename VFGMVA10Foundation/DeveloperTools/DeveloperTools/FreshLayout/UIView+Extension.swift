//
//  UIView+Extension.swift
//  ewdewfd
//
//  Created by Claudio Cavalli on 18/05/22.
//

import Foundation
import UIKit

public extension UIView {
    // get FreshLayout view
    var fresh: FreshLayout<UIView> { FreshLayout(wrappedValue: self) }
    
    // retrieves all constraints that mention the view.
    internal func getAllConstraints() -> [NSLayoutConstraint] {

        // array will contain self and all superviews.
        var views = [self]

        // get all superviews.
        var view = self
        while let superview = view.superview {
            views.append(superview)
            view = superview
        }

        /* transform views to constraints and filter only those
           constraints that include the view itself. */
        return views.flatMap({ $0.constraints }).filter { constraint in
            return constraint.firstItem as? UIView == self ||
                constraint.secondItem as? UIView == self
        }
    }
}
