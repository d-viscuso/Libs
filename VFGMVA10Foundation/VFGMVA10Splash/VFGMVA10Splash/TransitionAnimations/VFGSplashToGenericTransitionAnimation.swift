//
//  VFGSplashToGenericTransitionAnimation.swift
//  VFGMVA10Splash
//
//  Created by Hamsa Hassan on 9/22/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

class VFGSplashToGenericTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var duration = CircleMaskAnimationConstants.expandDuartion
    var transitionContext: UIViewControllerContextTransitioning?
    var circleSize: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CircleMaskAnimationConstants.expandSizeForIphone
        } else {
            return CircleMaskAnimationConstants.expandSizeForIpad
        }
    }

    /**
    returns duration for circle mask expand animation
    */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    /**
    applying animation transition from SplashViewController to 'Generic' ViewController
    */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        guard let fromVC = transitionContext.viewController(forKey: .from) as? VFGAnimatedSplashViewController,
            let toVC: UIViewController = transitionContext.viewController(forKey: .to),
            let toView = toVC.view else {
                return
        }
        let containerView = transitionContext.containerView
        containerView.backgroundColor = fromVC.view.backgroundColor
        containerView.subviews.first?.backgroundColor = UIColor.clear
        containerView.embed(view: toView)
        containerView.sendSubviewToBack(toView)
        startMaskAnimation(fromVC: fromVC, toVC: toVC)
        postSplashContentScaleUpAnimation(toView: toVC.view)
    }

    /**
    Apply scale animation for post Splash content
    */
    func postSplashContentScaleUpAnimation(toView: UIView) {
        UIView.animateKeyframes(
            withDuration: PostSplashToGenericAnimationConstants.duration,
            delay: PostSplashToGenericAnimationConstants.delay,
            options: [.calculationModePaced],
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 1) {
                        toView.transform = CGAffineTransform(
                            scaleX: PostSplashToGenericAnimationConstants.scaleEndRatio,
                            y: PostSplashToGenericAnimationConstants.scaleEndRatio)
                }
            }, completion: nil)
    }

    /**
    Apply circle mask expand animation
    */
    func startMaskAnimation(fromVC: VFGAnimatedSplashViewController, toVC: UIViewController) {
        guard let toView = toVC.view else {
            return
        }
        let maskPath = UIBezierPath(ovalIn: fromVC.circleMask.frame)
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        toVC.view.layer.mask = maskLayer
        let endFrame = calculateEndFrame(with: toView.frame)
        let bigCirclePath = UIBezierPath(ovalIn: endFrame)
        toView.transform = CGAffineTransform(
            scaleX: PostSplashToGenericAnimationConstants.scaleBeginRatio,
            y: PostSplashToGenericAnimationConstants.scaleBeginRatio)
        let pathAnimation = CABasicAnimation(keyPath: BasicAnimationKeys.pathKey)
        pathAnimation.delegate = self
        pathAnimation.fromValue = maskPath.cgPath
        pathAnimation.timingFunction = CAMediaTimingFunction.easeInQuart
        pathAnimation.toValue = bigCirclePath

        pathAnimation.duration = transitionDuration(using: transitionContext)
        maskLayer.path = bigCirclePath.cgPath
        maskLayer.add(pathAnimation, forKey: BasicAnimationKeys.pathKey)
    }

    /**
    calculates maximum expansion size for circle based on device type iPhone/iPad
    */
    fileprivate func calculateEndFrame(with viewFrame: CGRect) -> CGRect {
        let expandSize: CGFloat = circleSize
        let xPosition: CGFloat = expandSize - viewFrame.width
        let yPosition: CGFloat = expandSize - viewFrame.height
        return  CGRect(x: -1 * (xPosition / 2), y: -1 * (yPosition / 2), width: expandSize, height: expandSize)
    }
}

extension VFGSplashToGenericTransitionAnimation: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        transitionContext?.completeTransition(true)
        guard let fromVC = transitionContext?.viewController(forKey: .from) as? VFGAnimatedSplashViewController else {
            return
        }
        fromVC.resetAnimations()
    }
}
