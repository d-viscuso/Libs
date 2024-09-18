//
//  UIStackView+ArrangedSubviews.swift
//  VFGMVA10Foundation
//
//  Created by Abdullah Soylemez on 28.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

extension UIStackView {
    /// Removes all arranged sub-views inside the current UIStackView object.
    /// - Parameters:
    ///    - shouldDeactivateConstraints: Deactivates the sub-views constraints, it is true by default.
    public func removeAllArrangedSubviews(shouldDeactivateConstraints: Bool = true) {
        let removedSubviews = arrangedSubviews.reduce([]) { allSubviews, subview -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }

        // Deactivate all constraints
        if shouldDeactivateConstraints {
            NSLayoutConstraint.deactivate(removedSubviews.flatMap { $0.constraints })
        }

        // Remove the views from self
        removedSubviews.forEach { $0.removeFromSuperview() }
    }

    /// Hides all arranged sub-views inside the current UIStackView object.
    public func hideAllArrangedSubviews() {
        arrangedSubviews.forEach { $0.isHidden = true }
    }
}
