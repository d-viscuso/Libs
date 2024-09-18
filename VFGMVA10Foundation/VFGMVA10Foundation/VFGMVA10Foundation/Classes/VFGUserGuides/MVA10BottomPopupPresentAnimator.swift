//
//  MVA10BottomPopupPresentAnimator.swift
//  MyVodafone
//
//  Created by Ramy Nasser on 6/18/19.
//  Copyright © 2019 TSSE. All rights reserved.
//

import UIKit

class MVA10BottomPopupPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private weak var attributesOwner: MVA10BottomPresentableViewController?

    init(attributesOwner: MVA10BottomPresentableViewController) {
        self.attributesOwner = attributesOwner
    }
    // asks the animation controller for the duration of its animation
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return attributesOwner?.getPopupPresentDuration() ?? 0.0
    }
    // perform the animation for the transition
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // ask the “to” (the view controller to be shown) for its transitioning delegate .
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        transitionContext.containerView.addSubview(toVC.view)
        let presentFrame = transitionContext.finalFrame(for: toVC)
        let origin = CGPoint(x: presentFrame.origin.x, y: UIScreen.main.bounds.size.height)
        let initialFrame = CGRect(origin: origin, size: presentFrame.size)
        toVC.view.frame = initialFrame
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration) { toVC.view.frame = presentFrame } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
