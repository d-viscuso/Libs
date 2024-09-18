//
//  VFGTrayViewController+SplashDelegate.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 1/29/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGTrayViewController: VFGMVa10SplashDelegate {
    public func splashTransitionsWillStart(duration: Double, delay: Double, completion: (() -> Void)? = nil) {
        if !useSplashDefaultAnimation {
            mainTrayView.transform = CGAffineTransform(translationX: 0, y: trayViewHeight)
            UIView.animate(
                withDuration: duration,
                delay: delay,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 1.0,
                animations: { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.mainTrayView.transform = .identity
                    self.mainTrayView.center = CGPoint(
                        x: self.mainTrayView.frame.midX,
                        y: self.mainTrayView.frame.midY)

                    // for testing purposes
                    guard let completion = completion else {
                        return
                    }
                    completion()
                }, completion: nil)
        }
        if let nextViewController = rootViewController as? VFGMVa10SplashDelegate {
            nextViewController.splashTransitionsWillStart(duration: duration, delay: delay, completion: nil)
        }
    }

    public var logo: UIImage? {
        if let nextViewController = rootViewController as? VFGMVa10SplashDelegate {
            return nextViewController.logo
        }
        return nil
    }

    public var logoFrame: CGRect {
        if let nextViewController = rootViewController as? VFGMVa10SplashDelegate {
            return nextViewController.logoFrame
        }
        return CGRect.zero
    }

    public var useSplashDefaultAnimation: Bool {
        if let nextViewController = rootViewController as? VFGMVa10SplashDelegate {
            return nextViewController.useSplashDefaultAnimation
        }
        return false
    }

    public var nextViewControllerBGColor: UIColor? {
        if let nextViewController = rootViewController as? VFGMVa10SplashDelegate {
            return nextViewController.nextViewControllerBGColor
        }
        return nil
    }

    public var nextViewControllerBGImage: UIImage? {
        if let nextViewController = rootViewController as? VFGMVa10SplashDelegate {
            return nextViewController.nextViewControllerBGImage
        }
        return nil
    }

    public func splashTransitionsDidFinish() {
        if let nextViewController = rootViewController as? VFGMVa10SplashDelegate {
            nextViewController.splashTransitionsDidFinish()
        }
    }

    // this Overloading method is for testing purposes only
    func splashTransitionsWillStart(duration: Double, delay: Double, _ completion: (() -> Void)? = nil) {
        if let nextViewController = rootViewController as? VFGMVa10SplashDelegate {
            nextViewController.splashTransitionsWillStart(duration: duration, delay: delay, completion: completion)
        }
    }
}
