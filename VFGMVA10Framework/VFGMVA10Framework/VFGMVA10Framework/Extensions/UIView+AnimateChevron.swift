//
//  UIView+Animation.swift
//  VFGSOHOFramework
//
//  Created by Salma Ashour on 21/08/2021.
//

import UIKit
import VFGMVA10Foundation

public extension UIView {
    func animateChevronDown(completion: (() -> Void)? = nil) {
        self.transform = CGAffineTransform(rotationAngle: (-.pi * 0.99))
        UIView.animate(
            withDuration: Constants.EIOAnimation.expandingCollapsingDuration,
            delay: 0) {
            self.transform = .identity
            completion?()
        }
    }

    func animateChevronUp() {
        self.transform = .identity
        UIView.animate(
            withDuration: Constants.EIOAnimation.expandingCollapsingDuration,
            delay: 0) {
            self.transform = CGAffineTransform(rotationAngle: (-.pi * 0.99))
        }
    }
}
