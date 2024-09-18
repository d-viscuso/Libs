//
//  UIView+Animation.swift
//  VFGMVA10Group
//
//  Created by ahmed mahdy on 10/17/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//
import UIKit

// TODO: move to foundation
extension UIView {
    func rotate360Degrees(completionDelegate: CAAnimationDelegate? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * -2.0)
        rotateAnimation.repeatCount = .infinity
        rotateAnimation.speed = 0.5

        if let delegate: CAAnimationDelegate = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }

    func blink(initialAlpha: CGFloat, duration: TimeInterval, delay: TimeInterval) {
        alpha = initialAlpha
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.repeat, .autoreverse, .curveEaseInOut],
            animations: {
                self.alpha = 1
            },
            completion: nil)
    }

    func viewAppearance(
        type: EIOCellProtocol.Type,
        duration: TimeInterval,
        delay: TimeInterval,
        completion: (() -> Void)? = nil
    ) {
        if type.isClicked {
            alpha = 0
            UIView.animate(
                withDuration: duration,
                delay: delay,
                animations: { [weak self] in
                    guard let self = self else { return }
                    self.alpha = 1
                }, completion: ({ _ in
                    type.isClicked = false
                    completion?()
                }))
        }
    }
}
