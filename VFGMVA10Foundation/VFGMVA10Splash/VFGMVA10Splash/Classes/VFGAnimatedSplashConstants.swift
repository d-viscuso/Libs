//
//  VFGAnimatedSplashConstants.swift
//  VFGMVA10Splash
//
//  Created by Hamsa Hassan on 9/24/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

/*Splash Transition to Generic Views Animation Constants */
enum BasicAnimationKeys {
    static let pathKey: String = "path"
}

enum SplashToGenericAnimationConstants {
    static var duration: Double = 1.0
    static var delay: Double = 1.0
    static var scaleDownStartTime: Double = 0.0
    static var scaleDownDuration: Double = 0.933
    static let scaleDownRatio: CGFloat = 0.10
    static var fadeOutStartTime: Double = 0.33
    static var fadeOutDuration: Double = 0.2
}

enum CircleMaskAnimationConstants {
    static let expandDuartion: Double = 0.5
    static let expandSizeForIpad: CGFloat = 2000.0
    static let expandSizeForIphone: CGFloat = 1050
    static let delay: Double = 0.9
}

enum PostSplashToGenericAnimationConstants {
    static let duration: Double = 0.15
    static let delay: Double = 0.233
    static let scaleBeginRatio: CGFloat = 0.75
    static let scaleEndRatio: CGFloat = 1.0
}

// Splash Transition to Dashboard Animation Constants
enum SplashToDashboardAnimationConstants {
    static let duration: Double = 1.2
    static let delay: Double = 1.0
    static let scaleDownStartTime: Double = 0.0
    static let scaleDownDuration: Double = 0.5
    static let translateStartTime: Double = 0.16
    static let translateDuration: Double = 0.3
    static let showViewControllerDuration: Double = 0.4
}

enum BackgroundFadeAnimationConstants {
    static let startTime: Double = 0.12
    static let duration: Double = 0.83
}

enum PostSplashToDashboardAnimationConstants {
    static let delay: Double = 1.2
}
