//
//  VFGDashboardToEIOKDismissAnimation.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 12/22/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGDashboardToEIOKAnimation {
    func dismiss(transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext
                .viewController(forKey: .from) as? VFEverythingIsOKChecksViewController else { return }

        transitionContext.containerView.addSubview(toViewController.view)
        dashboardTransitionView = transitionContext.viewController(forKey: .to)?.view ?? UIView()

        eiokVC = fromViewController

        var transitionImageViewsFinalFrames: [CGRect] = []
        eioManager.dashboardHeader?.iconsContainerView?.subviews.forEach { imageView in
            transitionImageViewsFinalFrames.append(actualFrame(of: imageView, to: dashboardTransitionView))
        }
        transitionImageViewsFinalFrames.reverse()

        setupTransitionLabels(initialAlpha: 0)
        transitionLabels.forEach {
            transitionContext.containerView.addSubview($0)
        }

        let currentSectionsExpandState = eiokVC?.checks.map { $0.willExpand }
        setupDismissing()

        transitionImageViews.forEach { imageView in
            if let imageView = imageView {
                transitionContext.containerView.addSubview(imageView)
            }
        }

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(
            withDuration: duration,
            animations: { [weak self] in
                guard let self = self else { return }

                self.dashboardTransitionView.frame.origin.y = 0

                if self.eiokVC?.eioModel?.eioStatus != .success {
                    for index in 0..<min(self.transitionImageViews.count, transitionImageViewsFinalFrames.count) {
                        self.transitionImageViews[index]?.frame = transitionImageViewsFinalFrames[index]
                    }
                }
            },
            completion: { _ in
                toViewController.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                self.setEIOKIconsAlpha(alpha: 1)
                self.finishTransition()
                self.eiokVC?.shouldReloadOnAppear = true
                for index in 0..<min(currentSectionsExpandState?.count ?? 0, self.eiokVC?.checks.count ?? 0) {
                    self.eiokVC?.checks[index].willExpand = currentSectionsExpandState?[index] ?? false
                }
                self.eiokVC?.reloadAllSections(animated: false)
            }
        )
    }

    func setupDismissing() {
        guard let eiokVC = eiokVC else {
            return
        }
        eiokVC.shouldReloadOnAppear = false
        eiokVC.backgroundView.alpha = 1
        eiokVC.closeAllSections(animated: false)
        eioManager.dashboardVC.view.frame.origin.y = UIScreen.main.bounds.height

        eioManager.dashboardHeader?.isHidden = true
        eioManager.backgroundView?.alpha = 0
        setupTransitionIcons()
        eioManager.collectionView.reloadData()
        eiokImageViews = []
        for sectionIndex in 0..<(eiokVC.checksTableView?.numberOfSections ?? 0) {
            let section = eiokVC.checksTableView
                .headerView(forSection: sectionIndex) as? VFEverythingIsOKChecksHeaderCell
            if let icon = section?.headerIcon {
                eiokImageViews.append(icon)
            }
        }

        displayLink = CADisplayLink(target: self, selector: #selector(transitionAnimation))
        displayLink?.add(to: .current, forMode: .common)
    }

    private func setupIconsLowerBounds(
        _ lowerOutOfBoundsIcons: [VFGImageView],
        _ outOfBoundsMaxY: CGFloat,
        _ tableViewRowHeight: CGFloat
    ) {
        for (index, icon) in lowerOutOfBoundsIcons.enumerated() {
            icon.alpha = 0
            icon.frame.origin.y = outOfBoundsMaxY +
                (icon.bounds.height * CGFloat(index)) + (CGFloat(index) * tableViewRowHeight)
        }
    }

    private func setupIconsUpperBounds(
        _ upperOutOfBoundsIcons: [VFGImageView],
        _ outOfBoundsMinY: CGFloat,
        _ tableViewRowHeight: CGFloat
    ) {
        for (index, icon) in upperOutOfBoundsIcons.enumerated() {
            icon.alpha = 0
            let reversedIndex = CGFloat(upperOutOfBoundsIcons.count - index)
            icon.frame.origin.y = outOfBoundsMinY -
                (icon.bounds.height * reversedIndex) - (reversedIndex * tableViewRowHeight)
        }
    }

    func setupTransitionIcons() {
        guard let eiokVC = eiokVC else {
            return
        }
        guard eiokVC.eioModel?.eioStatus != .success else { return }
        setEIOKIconsAlpha(alpha: 0)
        transitionImageViews = []
        dashboardImageViews = []
        let tableViewFrame = actualFrame(of: eiokVC.checksTableView)
        let tableViewRowHeight: CGFloat = eiokVC.checksTableView.headerView(forSection: 0)?.frame.height ?? 20
        var dashboardIcons = eioManager
            .dashboardHeader?.iconsContainerView?.subviews
        let eiokIconsFrames = eiokChecksActualFrames()

        dashboardIcons?.reverse()
        outOfBoundsIcons = []
        var upperOutOfBoundsIcons: [VFGImageView] = []
        var lowerOutOfBoundsIcons: [VFGImageView] = []
        var outOfBoundsMinY = tableViewFrame.minY
        var outOfBoundsMaxY = tableViewFrame.maxY
        for index in 0..<min(dashboardIcons?.count ?? 0, eiokIconsFrames.count) {
            let imageView = copyImageView(
                imageView: dashboardIcons?[index] as? VFGImageView,
                frame: eiokIconsFrames[index])
            dashboardImageViews.append(dashboardIcons?[index] as? VFGImageView ?? VFGImageView())
            if !isFrameInFrame(
                subFrame: eiokIconsFrames[index],
                superFrame: tableViewFrame) {
                outOfBoundsIcons.append(imageView)
                if eiokIconsFrames[index].minY < tableViewFrame.minY {
                    upperOutOfBoundsIcons.append(imageView)
                } else {
                    lowerOutOfBoundsIcons.append(imageView)
                }
            } else {
                outOfBoundsMinY = min(outOfBoundsMinY, imageView.frame.minY)
                outOfBoundsMaxY = max(outOfBoundsMaxY, imageView.frame.maxY)
            }
            transitionImageViews.append(imageView)
        }
        dashboardImageViews.reverse()
        setupIconsUpperBounds(upperOutOfBoundsIcons, outOfBoundsMinY, tableViewRowHeight)
        setupIconsLowerBounds(lowerOutOfBoundsIcons, outOfBoundsMaxY, tableViewRowHeight)
    }
}
