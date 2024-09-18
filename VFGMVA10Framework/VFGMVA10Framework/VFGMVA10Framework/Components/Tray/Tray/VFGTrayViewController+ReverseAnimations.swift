//
//  VFGTrayViewController+ReverseAnimations.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 2/19/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

extension VFGTrayViewController {
    func reverseTrayLabelsAnimation(animated: Bool = true) {
        pillView.layer.removeAllAnimations()
        let duration = animated ? Constants.TrayAnimations.reverseLabelsDuration : TimeInterval(0)
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.subTrayLabel.alpha = 0
                self.closeButtonOutlet.alpha = 0
                self.pillView.alpha = 0
                self.pillView.transform = CGAffineTransform(
                    translationX: 0,
                    y: self.sheetViewInitialY)
            },
            completion: nil)
    }

    func reverseTrayPlaceholderAnimation(animated: Bool = true) {
        sheetView.layer.removeAllAnimations()
        backgroundOverlay.layer.removeAllAnimations()
        let duration = animated ? Constants.TrayAnimations.reverseTrayPlaceholderDuration : TimeInterval(0)
        UIView.animate(
            withDuration: duration,
            delay: Constants.TrayAnimations.reverseTrayPlaceholderDelay,
            options: .curveEaseOut,
            animations: {
                self.backgroundOverlay.alpha = 0
                self.sheetView.transform = CGAffineTransform(
                    translationX: 0,
                    y: self.sheetViewInitialY)
            },
            completion: { [weak self] _ in
                guard let self = self else { return }
                self.notifyTrayState()
                self.view.isUserInteractionEnabled = true
            })
        UIView.animate(
            withDuration: Constants.TrayAnimations.trayPlaceholderFade,
            delay: Constants.TrayAnimations.trayPlaceholderFadeOutDelay,
            options: .curveEaseInOut,
            animations: {
                self.sheetView.alpha = 0
            },
            completion: nil)
        UIView.animate(
            withDuration: Constants.TrayAnimations.trayPlaceholderFade,
            delay: Constants.TrayAnimations.sheetViewBottomFadeOutDelay,
            options: .curveEaseInOut,
            animations: {
                self.sheetViewBottomArea.alpha = 0
            },
            completion: nil)
    }

    func reverseTobiAnimation(animated: Bool = true) {
        tobiView.layer.removeAllAnimations()
        let duration = animated ? Constants.TrayAnimations.reverseTobiUpDuration : TimeInterval(0)
        UIView.animate(
            withDuration: duration,
            delay: Constants.TrayAnimations.reverseTobiDelay,
            options: .curveEaseInOut,
            animations: {
                self.tobiView.transform = .identity
                self.tobiView.alpha = 1
            },
            completion: nil)
    }
}
