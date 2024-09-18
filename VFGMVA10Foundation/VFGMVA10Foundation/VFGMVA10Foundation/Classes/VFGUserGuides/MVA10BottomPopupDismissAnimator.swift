//
//  MVA10BottomPopupDismissAnimator.swift
//  MyVodafone
//
//  Created by Ramy Nasser on 6/18/19.
//  Copyright © 2019 TSSE. All rights reserved.
//

import UIKit

class MVA10BottomPopupDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private weak var attributesOwner: MVA10BottomPresentableViewController?
    init(attributesOwner: MVA10BottomPresentableViewController) {
        self.attributesOwner = attributesOwner
    }
    // asks the animation controller for the duration of its animation
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return attributesOwner?.getPopupDismissDuration() ?? 0.0
    }
    // perform the animation for the transition
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // ask the “from” (the view controller to be dismiss) for its transitioning delegate .
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        let origin = CGPoint(x: fromVC.view.frame.origin.x, y: UIScreen.main.bounds.size.height)
        let dismissFrame = CGRect(origin: origin, size: fromVC.view.frame.size) // dismiss frame
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration) { fromVC.view.frame = dismissFrame } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
