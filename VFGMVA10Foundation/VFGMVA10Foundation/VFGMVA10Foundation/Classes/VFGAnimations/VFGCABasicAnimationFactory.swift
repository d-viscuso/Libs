//
//  VFGCABasicAnimationFactory.swift
//  VFGMVA10Foundation
//
//  Created by Fafoutis, Athinodoros, Vodafone Greece on 11/11/2020.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

public enum VFGCABasicAnimationFactory {
    /// Returns animation depending on the type provided.
    /// - Parameters:
    ///    - type: The type of wanted animation.
    /// - Returns: A *CAAnimationGroup* object.
    public static func getAnimation(for type: VFGAnimationType) -> CAAnimationGroup {
        switch type {
        case .shake:
            return getShakeAnimation()
        case .rotate360:
            return getRotateAnimation()
        }
    }

    /// Returns the shake animation.
    private static func getShakeAnimation() -> CAAnimationGroup {
        let shakeDuration = 0.10
        let numberOfShakes: Float = 3 // minimum number is 2

        let firstTurn = CABasicAnimation(keyPath: "transform.rotation.z")
        firstTurn.fromValue = 0
        firstTurn.toValue = -21.0 * Double.pi / 180.0
        firstTurn.duration = shakeDuration / 2
        firstTurn.beginTime = 0

        let shake = CABasicAnimation(keyPath: "transform.rotation.z")
        shake.fromValue = -21.0 * Double.pi / 180.0
        shake.toValue = 21.0 * Double.pi / 180.0
        shake.duration = shakeDuration
        shake.repeatCount = numberOfShakes - 1
        shake.beginTime = firstTurn.duration
        shake.autoreverses = true

        let lastTurn = CABasicAnimation(keyPath: "transform.rotation.z")
        lastTurn.fromValue = -21.0 * Double.pi / 180.0
        lastTurn.toValue = 0
        lastTurn.duration = shakeDuration / 2
        lastTurn.beginTime = firstTurn.duration + (shake.duration * 4)
        // x4 not 2 because the reverse takes the same time as the animation

        let group = CAAnimationGroup()
        group.animations = [firstTurn, shake, lastTurn]
        group.duration = shakeDuration + ((Double(numberOfShakes) - 1) * 2 * shakeDuration)
        return group
    }

    /// Reurns the rotation animation.
    private static func getRotateAnimation() -> CAAnimationGroup {
        let timeInterval: CFTimeInterval = 3
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = timeInterval

        let group = CAAnimationGroup()
        group.animations = [rotateAnimation]
        group.duration = rotateAnimation.duration

        return group
    }
}
