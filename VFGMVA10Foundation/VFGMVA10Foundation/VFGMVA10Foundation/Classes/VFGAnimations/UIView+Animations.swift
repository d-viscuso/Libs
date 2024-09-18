//
//  UIView+Animations.swift
//  VFGMVA10Foundation
//
//  Created by Fafoutis, Athinodoros, Vodafone Greece on 11/11/2020.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension UIView {
    /// Animates the view depending on the animation type provided.
    /// - Parameters:
    ///    - animationType: Type of the wanted animation.
    ///    - delay: Number of seconds you want animation takes, it is  nil by default.
    public func animate(_ animationType: VFGAnimationType, delay: Double? = nil) {
        let animation = VFGCABasicAnimationFactory.getAnimation(for: animationType)
        if let delay = delay {
            animation.beginTime = CACurrentMediaTime() + delay
        }
        layer.add(animation, forKey: animationType.rawValue)
    }

    /// Stops animation on the view depending on the animation type provided.
    public func stopAnimation(_ animationType: VFGAnimationType) {
        layer.removeAnimation(forKey: animationType.rawValue)
    }
}
