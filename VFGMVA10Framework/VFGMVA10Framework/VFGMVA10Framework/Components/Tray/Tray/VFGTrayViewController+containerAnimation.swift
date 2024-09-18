//
//  VFGTrayViewController+containerAnimation.swift
//  VFGMVA10Framework
//
//  Created by Ahmed Sultan on 10/15/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit

extension VFGTrayViewController {
    fileprivate func expandAnimationBlock() -> () -> Void {
        return { [weak self] in
            UIView.addKeyframe(
                withRelativeStartTime: 0.0,
                relativeDuration: 0.5) {[weak self] in
                    guard let self = self else {
                        return
                    }
                    self.bottomNotchTopConstraint.constant = self.extraBottomInset
                    self.bottomNotchBottomConstraint.constant = 0
                    self.tobiFaceBottomConstraint.constant =
                        -Constants.trayBottomPadding
                    self.customeSafeArea.bottom = self.extraBottomInset
                    self.additionalSafeAreaInsets = self.customeSafeArea
                    self.view.layoutIfNeeded()
            }
            UIView.addKeyframe(
                withRelativeStartTime: 0.5,
                relativeDuration: 0.5) {[weak self] in
                    guard let self = self else {
                        return
                    }
                    self.tobiContainerViewHeight.constant
                        = UIScreen.main.bounds.height * (15 / 20)
                    self.view.layoutIfNeeded()
            }
            UIView.addKeyframe(
                withRelativeStartTime: 0.5,
                relativeDuration: 0.2) {[weak self] in
                    guard let self = self else {
                        return
                    }
                    self.rightItemsStackView.alpha = 0
                    self.leftItemsStackView.alpha = 0
            }
            UIView.addKeyframe(
                withRelativeStartTime: 0.5,
                relativeDuration: 0.5) { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.closeBtn?.alpha = 1
                    self.tobiContainerView.alpha = 1
                    self.tobiBackButton.alpha = 0
                    self.hideSuperViews()
                    self.view.layoutSubviews()
            }
        }
    }

    func tobiContainerWillExpand() {
    minimizeTobiTimer?.invalidate()
    UIView.animateKeyframes(
        withDuration: 1.0,
        delay: 0,
        options: .calculationModeLinear,
        animations: expandAnimationBlock(),
        completion: nil)
}

    fileprivate func collapsAnimationBlock(_ trayStyle: VFGTrayStyle) -> () -> Void {
        return { [weak self] in
            UIView.addKeyframe(
                withRelativeStartTime: 0.0,
                relativeDuration: 0.5) {[weak self] in
                    guard let self = self else {
                        return
                    }
                    self.tobiContainerViewHeight.constant =
                        self.expandViewInitialY
                    self.view.layoutIfNeeded()
            }
            UIView.addKeyframe(
                withRelativeStartTime: 0.3,
                relativeDuration: 0.2) {[weak self] in
                    guard let self = self else {
                        return
                    }
                    self.closeBtn?.alpha = 0
                    self.tobiBackButton.alpha = 0
                    self.tobiContainerView.alpha = 0
                    self.showSuperViews()
                    self.view.layoutSubviews()
            }
            UIView.addKeyframe(
                withRelativeStartTime: 0.5,
                relativeDuration: 0.5) {[weak self] in
                    guard let self = self else {
                        return
                    }
                    if trayStyle == .TOBI {
                        self.hideTrayWithoutAnimation()
                    }
                    self.view.layoutIfNeeded()
            }
            UIView.addKeyframe(
                withRelativeStartTime: 0.3,
                relativeDuration: 0.2) { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.rightItemsStackView.alpha = 1
                    self.leftItemsStackView.alpha = 1
            }
        }
    }

    func tobiContainerWillCollapse(trayStyle: VFGTrayStyle, completion: (() -> Void)? = nil) {
    UIView.animateKeyframes(
        withDuration: 1.0,
        delay: 0.0,
        options: .calculationModeLinear,
        animations: collapsAnimationBlock(trayStyle)) { _ in
        self.contentBGImageView.image = nil
        completion?()
    }
    }
}
