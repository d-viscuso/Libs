//
//  UIView+Rotate.swift
//  VFGMVA10Foundation
//
//  Created by Abdullah Soylemez on 28.07.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

extension UIView {
    /// Rotates current view by the given value.
    /// - Parameters:
    ///    - toValue: Value of the rotation.
    ///    - duration: Duration of the animation.
    public func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")

        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards

        layer.add(animation, forKey: nil)
    }
}
