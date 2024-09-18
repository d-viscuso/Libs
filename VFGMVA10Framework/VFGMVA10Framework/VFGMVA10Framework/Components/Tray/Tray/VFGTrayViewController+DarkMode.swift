//
//  VFGTrayViewController+DarkMode.swift
//  VFGMVA10Framework
//
//  Created by Hussien Gamal Mohammed on 4/9/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation
import Lottie

extension VFGTrayViewController {
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                setupTrayAnimation(isFirstSetup: false)
            }
        } else {
            return
        }
    }

    func setupTrayAnimation(isFirstSetup: Bool = true) {
        var animationName = trayAnimation
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                animationName = animationName.darkMode()
            }
        }

        guard let centerAnimatedView = centerAnimatedView else { return }

        centerAnimatedView.animation = Animation.named(
            animationName,
            bundle: Bundle.mva10Framework)
        centerAnimatedView.contentMode = .scaleAspectFill
        if isFirstSetup {
            animatedTrayBarContainer.isHidden = true
            centerAnimationCurrentProgress = 0
            centerAnimatedView.play(toProgress: centerAnimationCurrentProgress)
        } else {
            centerAnimatedView.currentProgress = centerAnimationCurrentProgress
        }
        centerAnimatedView.animationSpeed = Constants.TrayAnimations.trayLottieSpeedPercentage
    }
}
