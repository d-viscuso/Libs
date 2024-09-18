//
//  VFGSplashToDashboardTransitionAnimation.swift
//  VFGMVA10Splash
//
//  Created by Hussein Kishk on 9/23/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

class VFGSplashToDashboardTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var duration = SplashToDashboardAnimationConstants.showViewControllerDuration
    var dismissCompletion: (() -> Void)?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func endTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to) as? VFGMVa10SplashDelegate
        toVC?.splashTransitionsDidFinish()
        transitionContext.completeTransition(true)
    }

    fileprivate func animateView(
        _ toView: UIView,
        _ finalFrame: CGRect,
        _ transitionContext: UIViewControllerContextTransitioning,
        _ fromVC: VFGAnimatedSplashViewController
    ) {
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            animations: {
                toView.transform = .identity
                toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                toView.layer.cornerRadius = 0.0
            }, completion: { [weak self] _ in
                self?.endTransition(transitionContext: transitionContext)
                fromVC.resetAnimations()
            })
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) as? VFGMVa10SplashDelegate,
        let fromVC = transitionContext.viewController(forKey: .from) as? VFGAnimatedSplashViewController else {
            return
        }
        toVC.splashTransitionsWillStart(duration: duration, delay: 0.0, completion: nil)
        if toVC.useSplashDefaultAnimation {
            let finalFrame = toView.frame
            let initialFrame = CGRect(
                x: CGRect.zero.origin.x,
                y: UIScreen.main.bounds.maxY,
                width: toView.frame.width,
                height: toView.frame.height)
            let xScaleFactor = initialFrame.width / finalFrame.width
            let yScaleFactor = initialFrame.height / finalFrame.height
            let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
            toView.transform = scaleTransform
            toView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            toView.clipsToBounds = true
            toView.layer.cornerRadius = 20.0
            toView.layer.masksToBounds = true
            containerView.addSubview(toView)
            containerView.backgroundColor = toVC.nextViewControllerBGColor
            containerView.bringSubviewToFront(toView)
            animateView(toView, finalFrame, transitionContext, fromVC)
        } else {
            containerView.addSubview(toView)
            toView.backgroundColor = .clear
            if toVC.nextViewControllerBGImage == nil {
                containerView.backgroundColor = toVC.nextViewControllerBGColor
            }
            containerView.bringSubviewToFront(toView)
            DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.2) { [weak self] in
                self?.endTransition(transitionContext: transitionContext)
            }
        }
    }
}
