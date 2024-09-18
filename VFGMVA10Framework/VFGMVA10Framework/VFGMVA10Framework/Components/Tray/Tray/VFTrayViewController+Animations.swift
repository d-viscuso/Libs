//
//  VFGTrayViewController+Animations.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 4/9/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import VFGMVA10Foundation

extension VFGTrayViewController {
    func animateTobi() {
        tobiView.layer.removeAllAnimations()
        UIView.animate(
            withDuration: Constants.TrayAnimations.tobiDownDuration,
            delay: Constants.TrayAnimations.tobiDelay,
            options: .curveEaseInOut,
            animations: {
                var tobiAnimation = CGAffineTransform.identity
                tobiAnimation = tobiAnimation.translatedBy(x: 0, y: -Constants.TrayAnimations.tobiDisplacement)
                tobiAnimation = tobiAnimation.scaledBy(x: 0.8, y: 0.8)
                self.tobiView.transform = tobiAnimation
                self.tobiView.alpha = 0
            },
            completion: nil)
    }

    func animateTrayPlaceholder() {
        sheetView.layer.removeAllAnimations()
        pillView.layer.removeAllAnimations()
        backgroundOverlay.layer.removeAllAnimations()
        sheetView.transform = CGAffineTransform(translationX: 0, y: 0)
        sheetViewBottomArea.alpha = 1
        UIView.animate(withDuration: Constants.TrayAnimations.trayPlaceholderFade) {
            self.sheetView.alpha = 1
        }
        UIView.animate(
            withDuration: Constants.TrayAnimations.trayPlaceholderDuration,
            delay: Constants.TrayAnimations.trayPlaceholderDelay,
            options: .curveEaseOut,
            animations: {
                self.pillView.alpha = 1
                self.pillView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.backgroundOverlay.alpha = 1
            },
            completion: nil)
    }

    func animateTrayLabels(delay: TimeInterval = Constants.TrayAnimations.labelsDelay) {
        UIView.animate(
            withDuration: Constants.TrayAnimations.labelsDuration,
            delay: delay,
            options: .curveEaseInOut,
            animations: {
                self.subTrayLabel.alpha = 1
                self.closeButtonOutlet.alpha = 1
            },
            completion: { [weak self] _ in
                self?.view.isUserInteractionEnabled = true
            })
    }

    func collapseTOBIFace(completion: (() -> Void)? = nil) {
        self.titleLabel?.removeFromSuperview()
        minimizeTobiTimer?.invalidate()
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            animations: {
                self.tobiViewWidth.constant = Constants.trayViewWidth
                self.layoutTrayViews()
            },
            completion: {[weak self] _ in
                self?.leftSwipe?.isEnabled = false
                self?.rightSwipe?.isEnabled = false
                completion?()
            })
    }

    func expandTOBIFace(completion: (() -> Void)? = nil) {
        self.tobiView.addSubview(self.titleLabel ?? UIView())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.titleLabel?.fadeTransition(0.35)
            if self.titleLabel?.text == nil || (self.titleLabel?.text?.isEmpty ?? false) {
                self.titleLabel?.text = "tray_tobi_message".localized(bundle: Bundle.mva10Framework)
            }
            self.titleLabel?.alpha = 1
            completion?()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.titleLabel?.frame.size.width =
                UIScreen.main.bounds.width - self.tobiFace.frame.width - Constants.Dashboard.Layout.margin * 2
            self.titleLabel?.frame.size.height = self.tobiView.frame.height
        }
        removeTobiBadge()
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            animations: {
                self.tobiViewWidth.constant = UIScreen.main.bounds.width - Constants.Dashboard.Layout.margin
                self.tobiView.transform = .identity
                self.layoutTrayViews()
                self.tobiState = .expanded
            },
            completion: { [weak self] _ in
                self?.leftSwipe?.isEnabled = true
                self?.rightSwipe?.isEnabled = true
            })
    }

    func minimizeTobi() {
        let tobiWidth = Constants.trayViewWidth + Constants.Dashboard.Layout.margin * 2
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            animations: {
                self.titleLabel?.alpha = 0
                let moveRight =
                    CGAffineTransform(
                        translationX:
                        ((self.view.frame.width) / 2 - Constants.Dashboard.Layout.margin / 3),
                        y: 0.0)
                self.tobiView.transform = moveRight
                self.tobiViewWidth.constant = tobiWidth
                self.tobiState = .minimized
                self.layoutTrayViews()
            },
            completion: { [weak self] _ in
                if let topVC = UIApplication.topViewController() as? VFGTrayViewController {
                    if let root = topVC.rootViewController, let rootVC = UIApplication.topViewController(base: root) {
                        if let rootVC = rootVC as? VFGTrayContainerProtocol, rootVC.tobiMessageEnabled {
                            let key = rootVC.tobiKey
                            if topVC.tobiMessagesModel[key] != nil && !(self?.isTobiMessageViewed ?? false) {
                                self?.setTobiBadge(badgeLabel: topVC.tobiMessagesModel[key]?.tobiBadge)
                                self?.tobiFace.begin(topVC.tobiMessagesModel[key]?.tobiAnimation ?? .idle1)
                            }
                        }
                    }
                }
                self?.leftSwipe?.isEnabled = true
                self?.rightSwipe?.isEnabled = true
            })
    }

    func moveTobiToCenter(completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            animations: {
                self.tobiViewWidth.constant = Constants.trayViewWidth
                self.tobiView.transform = .identity
                self.layoutTrayViews()
            },
            completion: { _ in
                completion?()
            })
    }

    func setMinimizeTobiTimer() {
        minimizeTobiTimer?.invalidate()
        minimizeTobiTimer = Timer.scheduledTimer(
            withTimeInterval: tobiMessageTimer ??
                Constants.TobiMessages.welcomeMessageTimer,
            repeats: false) { [weak self] _ in
                self?.minimizeTobi()
        }
    }

    func addSwipeGestures() {
        guard let leftSwipe = leftSwipe, let rightSwipe = rightSwipe else {
            return
        }
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        tobiView.addGestureRecognizer(leftSwipe)
        tobiView.addGestureRecognizer(rightSwipe)
    }

    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            expandTOBIFace()
            setMinimizeTobiTimer()
        }

        if sender.direction == .right {
            minimizeTobi()
            minimizeTobiTimer?.invalidate()
        }
    }

    public func openTobiHelperInsideTray(embeddedVC: UIViewController) {
        if state == .expanded { return }
        state = .expanded
        notifyTrayState()
        addTobiExpandedVC(embeddedVC)
        mainTrayView.layoutSubviews()
        containerViewDashboard.isUserInteractionEnabled = false
        if let tobiViewPosition = tobiView?.convert(tobiView.frame, to: mainTrayView) {
            if tobiViewPosition.minX > (UIScreen.main.bounds.width) / 2 {
                self.moveTobiToCenter {
                    self.tobiContainerWillExpand()
                }
            } else {
                self.collapseTOBIFace {
                    self.tobiContainerWillExpand()
                }
                self.minimizeTobiTimer?.invalidate()
            }
        }
        titleLabel?.text = "tray_tobi_message".localized(bundle: Bundle.mva10Framework)
        removeTobiBadge()
        isTobiMessageViewed = true
        leftSwipe?.isEnabled = false
        rightSwipe?.isEnabled = false
        print("Tobi Action")
        if let navController = embeddedVC as? UINavigationController {
            navController.delegate = self
            navController.navigationBar.isHidden = true
            tobiHelpNavController = navController
        }
    }

    @objc func tobiFaceTapped() {
        if let navController = self.rootViewController,
        let topViewController = UIApplication.topViewController(base: navController),
        let trayDelegate = topViewController as? VFGTrayContainerProtocol {
            switch trayDelegate.tobiActionType {
            case .customAction(let tobiCustomAction):
                tobiCustomAction()
            default:
                if let embeddedVC = trayDelegate.tobiContainerVC {
                    openTobiHelperInsideTray(embeddedVC: embeddedVC)
                }
            }
        }
    }

    @objc func tobiCloseButtonTapped() {
        if let navController = self.rootViewController,
            let topViewController = UIApplication.topViewController(base: navController),
            let trayDelegate = topViewController as? VFGTrayContainerProtocol {
            containerViewDashboard.isUserInteractionEnabled = false
            tobiContainerWillCollapse(trayStyle: trayDelegate.trayStyle) {
                if trayDelegate.trayStyle == .TOBI {
                    if self.tobiState == .minimized {
                        self.minimizeTobi()
                    } else {
                        self.expandTOBIFace {
                            self.setMinimizeTobiTimer()
                        }
                    }
                }
                self.tobiContainerView.removeSubviews()
                self.containerViewDashboard.isUserInteractionEnabled = true
                self.tobiHelpNavController = nil
                self.state = .collapsed
                self.notifyTrayState()
            }
        }
    }

    func hideSuperViews() {
        tobiContainerTopBlurringView.alpha = 0.5
    }

    func showSuperViews() {
        tobiContainerTopBlurringView.alpha = 0
    }

    func hideTrayWithoutAnimation() {
        self.tobiFaceBottomConstraint.constant =
            -self.trayHeight - Constants.trayBottomPadding
        self.customeSafeArea.bottom = self.extraBottomInset
        self.bottomNotchTopConstraint.constant =
            self.trayHeight + self.extraBottomInset
        self.bottomNotchBottomConstraint.constant =
            -self.trayHeight - self.extraBottomInset
        self.additionalSafeAreaInsets = self.customeSafeArea
    }

    func addTobiExpandedVC(_ viewController: UIViewController) {
        viewController.willMove(toParent: self)
        tobiContainerView.addSubview(viewController.view)
        addChild(viewController)
        viewController.view.frame = tobiContainerView.bounds
        viewController.didMove(toParent: self)
        tobiContainerView.alpha = 0
    }

    public func showTOBIMessage(tobiMessageModel: TobiMessageModel, from viewController: VFGTrayContainerProtocol) {
        showTOBIMessage(tobiMessageModel: tobiMessageModel, from: viewController.tobiKey)
    }

    public func showTOBIMessage(tobiMessageModel: TobiMessageModel, from key: String) {
        tobiMessagesModel[key] = tobiMessageModel
        if let topVC = UIApplication.topViewController() as? VFGTrayViewController {
            if let root = topVC.rootViewController, let rootVC = UIApplication.topViewController(base: root) {
                if let rootVC = rootVC as? VFGTrayContainerProtocol {
                    let key = rootVC.tobiKey
                    if topVC.tobiMessagesModel[key] != nil {
                        topVC.setupTOBIMessage(key: key)
                        topVC.tobiMessageTimer = topVC.tobiMessagesModel[key]?.tobiMessageTimer ??
                            Constants.TobiMessages.welcomeMessageTimer
                    } else {
                        topVC.titleLabel?.text = nil
                        topVC.restoreTOBIBadge(for: key)
                        topVC.tobiMessageTimer = Constants.TobiMessages.welcomeMessageTimer
                    }
                }
            }
        }
    }
}
