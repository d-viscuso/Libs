//
//  VFGDashboardNavigationController+Splash.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 11/25/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension DashboardNavigationController: VFGMVa10SplashDelegate {
    var logoFrame: CGRect {
        return rootController?.logoFrame ?? CGRect.zero
    }

    var useSplashDefaultAnimation: Bool {
        return rootController?.useSplashDefaultAnimation ?? true
    }

    var nextViewControllerBGColor: UIColor? {
        return rootController?.nextViewControllerBGColor
    }

    var nextViewControllerBGImage: UIImage? {
        return rootController?.nextViewControllerBGImage
    }

    var logo: UIImage? {
        return rootController?.logo
    }

    func splashTransitionsWillStart(duration: Double, delay: Double, completion: (() -> Void)? = nil) {
        rootController?.splashTransitionsWillStart(duration: duration, delay: delay, completion: completion)
    }

    func splashTransitionsDidFinish() {
        rootController?.splashTransitionsDidFinish()
    }
}
