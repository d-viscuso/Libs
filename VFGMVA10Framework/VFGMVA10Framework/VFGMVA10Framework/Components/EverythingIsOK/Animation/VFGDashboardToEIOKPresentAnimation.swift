//
//  VFGDashboardToEIOKPresentAnimation.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 12/22/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGDashboardToEIOKAnimation {
    func present(transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext
            .viewController(forKey: .to) as? VFEverythingIsOKChecksViewController else { return }

        dashboardTransitionView = transitionContext.viewController(forKey: .from)?.view ?? UIView()
        transitionContext.containerView.addSubview(toViewController.view)
        transitionContext.containerView.sendSubviewToBack(toViewController.view)

        eiokVC = toViewController

        extraScrollOffset = min(eioManager.collectionView.contentOffset.y + VFGUISetup.statusBarHeight, 0)

        setupPresentation()

        setupTransitionLabels(extraOffset: extraScrollOffset)
        transitionLabels.forEach {
            transitionContext.containerView.addSubview($0)
        }

        transitionImageViews.reverse()
        let eiokFrames = self.eiokChecksActualFrames()
        if eioManager.eioModel?.eioStatus != .success {
            for index in 0..<min(transitionImageViews.count, eiokFrames.count) {
                transitionContext.containerView.addSubview(transitionImageViews[index] ?? VFGImageView())
            }
        }

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(
            withDuration: duration,
            animations: { [weak self] in
                guard let self = self else { return }

                self.dashboardTransitionView.frame.origin.y = UIScreen.main.bounds.height

                if self.eioManager.eioModel?.eioStatus != .success {
                    for index in 0..<min(self.transitionImageViews.count, eiokFrames.count) {
                        self.transitionImageViews[index]?.frame = eiokFrames[index]
                    }
                }
            },
            completion: { _ in
                self.setEIOKIconsAlpha(alpha: 1)
                self.finishTransition()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }

    func setupPresentation() {
        guard let eiokVC = eiokVC else {
            return
        }
        eiokVC.view.layoutIfNeeded()
        if eioManager.eioModel?.eioStatus != .success {
            setEIOKIconsAlpha(alpha: 0)
        }
        eiokVC.backgroundView.alpha = 1

        transitionImageViews = []
        dashboardImageViews = []
        if eioManager.eioModel?.eioStatus != .success {
            for subView in eioManager
                .dashboardHeader?.iconsContainerView.subviews ?? [] {
                    let imageView = subView as? VFGImageView
                    imageView?.frame = actualFrame(of: subView)
                    transitionImageViews.append(copyImageView(
                        imageView: imageView,
                        extraScrollOffset: extraScrollOffset))
                    dashboardImageViews.append(imageView ?? VFGImageView())
            }
        }

        transitionLabels.forEach { $0.alpha = 1 }
        eioManager.dashboardHeader?.isHidden = true
        eioManager.backgroundView?.alpha = 0
        eiokVC.checksTableView?.alpha = 0
        eiokVC.descriptionLabelContainer?.alpha = 0
        eiokVC.closeButton?.alpha = 0

        displayLink = CADisplayLink(target: self, selector: #selector(transitionAnimation))
        displayLink?.add(to: .current, forMode: .common)
    }
}
