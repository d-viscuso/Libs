//
//  VFGAnimatedSplashViewController.swift
//  VFGMVA10Splash
//
//  Created by Hamsa Hassan on 9/19/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation
/// The first screen that appears when the user lunches the app
/// It shows vodafone logo with animations
public class VFGAnimatedSplashViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var circleMask: UIView!
    @IBOutlet weak var splashLogo: UIImageView!
    @IBOutlet weak var backgroundView: UIView!

    var didShowGenericTransition = false
    var delayAmount = 2
    var presentDelay = 0.0
    var animationTriggerTime: Date?
    let today = Date()
    var shouldPresent = false
    var scaleRatios: CGFloat = 0.10
    var nextViewController: UIViewController?
    var completion: (() -> Void)?
    var flag = false

    let pageName = "Splash"
    let pageSection = "Splash"
    /// Static variable for tealium analytics manager
    public static var analyticsManager = VFGAnalyticsManager.self

    var transitionAnimationObject: UIViewControllerAnimatedTransitioning? {
        if didShowGenericTransition ||
            (nextViewController is UIAlertController) {
            return nil
        }

        if (nextViewController != nil), ((nextViewController as? VFGMVa10SplashDelegate) != nil) {
            return VFGSplashToDashboardTransitionAnimation()
        } else {
            return VFGSplashToGenericTransitionAnimation()
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        animationTriggerTime = Calendar.current.date(byAdding: .second, value: delayAmount, to: today)
        _ = Timer.scheduledTimer(
            timeInterval: TimeInterval(delayAmount),
            target: self,
            selector: #selector(executeAnimation),
            userInfo: nil,
            repeats: false)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackView()
    }

    override public func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        if shouldPresent {
            animationStart(
                viewControllerToPresent,
                animated: flag,
                completion: completion)
        } else {
            nextViewController = viewControllerToPresent
            self.completion = completion
            self.flag = flag
        }
    }

    func animationStart(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        start(nextViewController: viewControllerToPresent)
        DispatchQueue.main.asyncAfter(
            deadline: .now() + presentDelay) { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.presentOnSuper(viewControllerToPresent, animated: flag, completion: completion)
        }
    }

    @objc func executeAnimation() {
        shouldPresent = true
        guard let nextViewController = nextViewController else {
            return
        }
        animationStart(
            nextViewController,
            animated: flag,
            completion: completion)
    }

    func presentOnSuper(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    func start(nextViewController: UIViewController) {
        self.nextViewController = nextViewController
        nextViewController.transitioningDelegate = self

        if nextViewController is VFGMVa10SplashDelegate {
            splashToDashboardLogoAnimations()
        } else {
            splashToGenericLogoAnimations()
        }
    }

    func splashToDashboardLogoAnimations(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let splashDelegate = nextViewController as? VFGMVa10SplashDelegate else { return }
        let scaleRatio = splashDelegate.logoFrame.width / splashLogo.frame.size.width
        DispatchQueue.main.asyncAfter(deadline: .now() + (animated ? 1.1 : 0)) { [weak self] in
            guard let `self` = self else { return }
            UIView.transition(
                with: self.splashLogo,
                duration: (animated ? 0.2 : 0),
                options: .transitionCrossDissolve,
                animations: {
                    self.splashLogo.image = splashDelegate.logo
                }, completion: nil)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + (animated ? 1.1 : 0)) { [weak self] in
            guard let `self` = self else { return }

            UIView.transition(
                with: self.backgroundView,
                duration: (animated ? 0.5 : 0),
                options: .transitionCrossDissolve,
                animations: {
                    let startPoint = CGPoint(x: 1.0, y: 0.0)
                    self.backgroundView.setGradientBackgroundColor(
                        colors: UIColor.VFGDashBoardGradient,
                        startPoint: startPoint
                    )
                }, completion: nil)
        }

        UIView.animate(
            withDuration: (animated ? 0.6 : 0),
            delay: (animated ? 1 : 0),
            options: [.curveEaseInOut]) {
            self.contentView.transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
        }
        UIView.animate(
            withDuration: (animated ? 0.4 : 0),
            delay: (animated ? 1.2 : 0),
            options: [.curveEaseOut],
            animations: {
                self.contentView.translatesAutoresizingMaskIntoConstraints = true
                self.contentView.frame = splashDelegate.logoFrame
            }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + (animated ? 2.2 : 0)) { [weak self] in
            splashDelegate.splashTransitionsDidFinish()
            self?.resetAnimations(completion: completion)
        }
        presentDelay = 1.2
    }

    /**
    Splash to Generic
    */
    func splashToGenericLogoAnimations(completion: (() -> Void)? = nil) {
        UIView.animateKeyframes(
            withDuration: SplashToGenericAnimationConstants.duration,
            delay: SplashToGenericAnimationConstants.delay,
            options: .calculationModeLinear) { [weak self] in
            // logo scale down
            UIView.addKeyframe(
                withRelativeStartTime: SplashToGenericAnimationConstants.scaleDownStartTime,
                relativeDuration:
                    SplashToGenericAnimationConstants.scaleDownDuration) { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.splashLogo.transform = CGAffineTransform(
                    scaleX: SplashToGenericAnimationConstants.scaleDownRatio,
                    y: SplashToGenericAnimationConstants.scaleDownRatio)
            }
                // logo fade out
            UIView.addKeyframe(
                withRelativeStartTime:
                    SplashToGenericAnimationConstants.fadeOutStartTime,
                relativeDuration:
                    SplashToGenericAnimationConstants.fadeOutDuration) {
                self?.splashLogo.alpha = 0
            }
                completion?()
        }
        presentDelay = CircleMaskAnimationConstants.delay
    }

    func resetAnimations(completion: (() -> Void)? = nil) {
        contentView.center = view.center
        splashLogo.transform = CGAffineTransform(scaleX: 1, y: 1)
        view.layer.mask = nil
        view.backgroundColor = .VFGRedDefaultBackground
        backgroundView.isHidden = true
        splashLogo.isHidden = true
        splashLogo.alpha = 0
        completion?()
    }

    override public var prefersStatusBarHidden: Bool {
        return true
    }
}

extension VFGAnimatedSplashViewController {
    class func instance() -> VFGAnimatedSplashViewController {
        return VFGAnimatedSplashViewController.instance(from: String("VFGAnimatedSplash"), bundle: Bundle.MVA10Splash)
    }
}

extension VFGAnimatedSplashViewController: UIViewControllerTransitioningDelegate {
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        let returnObject = transitionAnimationObject
        didShowGenericTransition = true
        return returnObject
    }

    public func animationController(forDismissed
        dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

extension VFGAnimatedSplashViewController {
    func trackView() {
        let parameters: [String: String] = [
            VFGAnalyticsKeys.pageName: pageName,
            VFGAnalyticsKeys.pageSection: pageSection
        ]

        VFGAnimatedSplashViewController.analyticsManager.trackView(parameters: parameters, bundle: .MVA10Splash)
    }
}
