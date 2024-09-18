//
//  VFGTrayViewController+VFGTrayAnimation.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 1/16/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

extension VFGTrayViewController {
    func hideTrayAnimation(animated: Bool = true, hideTobiFace: Bool = true, completion: (() -> Void)? = nil) {
        if !hideTobiFace {
            tobiFaceBottomConstraint.constant = -trayHeight - Constants.trayBottomPadding
            customeSafeArea.bottom = extraBottomInset
            bottomNotchTopConstraint.constant = trayHeight + extraBottomInset
            bottomNotchBottomConstraint.constant = -trayHeight - extraBottomInset
            completion?()
        } else {
            customeSafeArea.bottom = 0
            bottomNotchTopConstraint.constant = trayHeight
            bottomNotchBottomConstraint.constant = -trayHeight
            tobiFaceBottomConstraint.constant = -Constants.trayBottomPadding
        }
        additionalSafeAreaInsets = customeSafeArea
        if animated {
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.layoutTrayViews()
                },
                completion: { _ in
                    if !hideTobiFace {
                        self.expandTOBIFace {
                            self.addSwipeGestures()
                            self.setMinimizeTobiTimer()
                        }
                        completion?()
                    } else {
                        self.collapseTOBIFace()
                    }
                }
            )
        } else {
            self.layoutTrayViews()
        }
    }

    func layoutTrayViews() {
        view.layoutSubviews()
        mainTrayView.layoutSubviews()
    }

    func showTrayAnimation(animated: Bool = true, completion: (() -> Void)? = nil) {
        bottomNotchTopConstraint.constant = extraBottomInset
        bottomNotchBottomConstraint.constant = 0
        tobiFaceBottomConstraint.constant = -Constants.trayBottomPadding
        customeSafeArea.bottom = extraBottomInset
        additionalSafeAreaInsets = customeSafeArea
        moveTobiToCenter()
        collapseTOBIFace {
            if animated {
                UIView.animate(
                    withDuration: 0.5,
                    animations: {
                        self.layoutTrayViews()
                    },
                    completion: { _ in
                        completion?()
                    }
                )
            } else {
                self.layoutTrayViews()
                completion?()
            }
        }
    }

    func startAnimation(showTray: Bool) {
        if trayAnimator?.hasStarted ?? false { return }
        trayAnimator?.animator = UIViewPropertyAnimator(
            duration: 0.2,
            curve: .easeInOut) {
            if showTray {
                self.showTrayAnimation()
            } else {
                self.hideTrayAnimation()
            }
        }
        trayAnimator?.isShowAnimation = showTray
        trayAnimator?.animator?.startAnimation()
        trayAnimator?.animator?.pauseAnimation()
        trayAnimator?.hasStarted = true
    }

    func updateAnimation(percentComplete: CGFloat) {
        trayAnimator?.animator?.fractionComplete = percentComplete
    }

    func finishAnimation(
        shouldFinish: Bool,
        shouldDelayCompletion: Bool = false
    ) {
        if !(trayAnimator?.hasStarted ?? true) { return }
        trayAnimator?.hasStarted = false
        if !shouldFinish {
            trayAnimator?.animator?.isReversed = true
        }
        if !shouldDelayCompletion {
            continueAnimation(duration: shouldFinish ? 0.5 : 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if shouldDelayCompletion {
                self.continueAnimation(duration: 0)
            }
            if !shouldFinish {
                if self.trayAnimator?.isShowAnimation ?? true {
                    self.hideTrayAnimation(animated: false)
                } else {
                    self.showTrayAnimation(animated: false)
                }
            }
        }
    }

    func continueAnimation(duration: CGFloat) {
        trayAnimator?.animator?.continueAnimation(
            withTimingParameters: nil,
            durationFactor: duration)
    }

    public func autoAnimation(showTray: Bool) {
        if showTray {
            showTrayAnimation()
        } else {
            hideTrayAnimation()
        }
    }

    public func handleTray(style: VFGTrayStyle) {
        switch style {
        case .trayWithTOBI:
            showTrayAnimation()
        case .TOBI:
            hideTrayAnimation(hideTobiFace: false)
        case.none:
            hideTrayAnimation()
        default:
            break
        }
    }
}
