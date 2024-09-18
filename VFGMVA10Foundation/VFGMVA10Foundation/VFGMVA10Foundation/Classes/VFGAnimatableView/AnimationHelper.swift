//
//  AnimationHelper.swift
//  VFGMVA10Foundation
//
//  Created by Yahya Saddiq on 12/21/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Lottie

/// An extension of `Animation` model which is the top level model object in Lottie.
/// It holds all the animation data backing vodafone logo.
extension Animation {
    // MARK: - Vodafone Logo
    /// A static variable of type *Animation* which holds the vodafone logo white animation.
    public static var vodafoneLogoWhite = Animation.named("vodafoneLogoWhite", bundle: .foundation)
    /// A static variable of type *Animation* which holds the vodafone logo red animation.
    public static var vodafoneLogoRed = Animation.named("vodafoneLogoRed", bundle: .foundation)
    /// A static variable of type *Animation* which return vodafone white logo in dark mode
    /// and vodafone red logo in light mode.
    public static var vodafoneLogo: Animation? {
        if #available(iOS 13.0, *) {
            if UIApplication.topViewController()?.traitCollection.userInterfaceStyle == .dark {
                return vodafoneLogoWhite
            } else {
                return vodafoneLogoRed
            }
        }

        return vodafoneLogoRed
    }

    // MARK: - Tick
    /// A static variable of type *Animation* which holds the vodafone red tick animation.
    /// This animation is used to express successful scenarios like successful transaction.
    public static var tickRed = Animation.named("Top-up_Tick_Red", bundle: .foundation)
    /// A static variable of type *Animation* which holds the vodafone white tick animation.
    /// This animation is used to express successful scenarios like successful transaction.
    public static var tickWhite = Animation.named("Top-up_Tick_White", bundle: .foundation)
    /// A static variable of type *Animation* which return vodafone white tick in dark mode
    /// and vodafone red tick in light mode.
    /// This animation is used to express successful scenarios like successful transaction.
    public static var tick: Animation? {
        if #available(iOS 13.0, *) {
            if UIApplication.topViewController()?.traitCollection.userInterfaceStyle == .dark {
                return tickWhite
            } else {
                return tickRed
            }
        }

        return tickRed
    }
}
