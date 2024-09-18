//
//  VFGDashboardToEIOKAnimation.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 11/17/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

class VFGDashboardToEIOKAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval
    var isPresenting: Bool

    var eiokVC: VFEverythingIsOKChecksViewController?
    var transitionImageViews: [VFGImageView?] = []

    var dashboardImageViews: [VFGImageView] = []
    var eiokImageViews: [VFGImageView] = []
    var dashboardGreetingLabel: VFGLabel?
    var transitionLabels: [VFGLabel] = []
    var extraScrollOffset: CGFloat = 0
    var outOfBoundsIcons: [VFGImageView] = []

    var displayLink: CADisplayLink?

    let eioManager = VFGEIOManager.shared

    var dashboardTransitionView: UIView

    init(isPresenting: Bool = true, duration: TimeInterval = 1) {
        dashboardTransitionView = UIView()
        self.duration = duration
        self.isPresenting = isPresenting
        dashboardImageViews = []
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if VFGManagerFramework.dashboardDelegate?.dashboardManager?.customHeaderModel == nil {
            if isPresenting {
                present(transitionContext: transitionContext)
            } else {
                dismiss(transitionContext: transitionContext)
            }
        }
    }

    @objc func transitionAnimation() {
        guard let eiokVC = eiokVC else {
            return
        }
        let originalHeight = dashboardTransitionView.frame.height
        let lowerHeight = originalHeight / 6
        let upperHeight = originalHeight - lowerHeight
        var presentationFrameYPosition = dashboardTransitionView.layer.presentation()?.frame.origin.y ?? 0

        var upperPartAlpha: CGFloat = 1
        var lowerPartAlpha: CGFloat = 0

        if isPresenting {
            let presentationFrameYPositionIncrement = VFGUISetup.statusBarHeight -
                eioManager.collectionView.contentOffset.y
            presentationFrameYPosition += presentationFrameYPositionIncrement
            upperPartAlpha = (upperHeight - presentationFrameYPosition) / upperHeight
            lowerPartAlpha = (presentationFrameYPosition - upperHeight) / lowerHeight
        } else {
            upperPartAlpha = (originalHeight - presentationFrameYPosition - lowerHeight) / upperHeight
            lowerPartAlpha = (lowerHeight + presentationFrameYPosition - originalHeight) / lowerHeight
        }

        transitionLabels.forEach { $0.alpha = upperPartAlpha }
        eiokVC.myProductsButton?.alpha = upperPartAlpha
        eiokVC.checksTableView.alpha = lowerPartAlpha
        eiokVC.descriptionLabelContainer.alpha = lowerPartAlpha
        eiokVC.closeButton.alpha = lowerPartAlpha

        // Update Blinking
        let originalImageViews = isPresenting ? dashboardImageViews : eiokImageViews
        let count = min(originalImageViews.count, transitionImageViews.count)
        for index in 0..<count {
            let currentAlpha = CGFloat(originalImageViews[index].layer.presentation()?.opacity ?? 0)
            let transitionIndex = isPresenting ? (count - index - 1) : index
            transitionImageViews[transitionIndex]?.alpha = currentAlpha
        }

        for icon in outOfBoundsIcons {
            icon.alpha = upperPartAlpha * 2
        }

        // Update transition greeting Label text on Presenting
        transitionLabels.first?.text = dashboardGreetingLabel?.text ?? ""
    }
}

// MARK: Helper Methods
extension VFGDashboardToEIOKAnimation {
    func eiokChecksActualFrames() -> [CGRect] {
        var frames: [CGRect] = []
        guard let eiokVC = eiokVC else {
            return frames
        }
        for index in 0..<eiokVC.checksTableView.numberOfSections {
            let section = eiokVC.tableView(
                eiokVC.checksTableView,
                viewForHeaderInSection: index) as? VFEverythingIsOKChecksHeaderCell

            let rectOfSectionInTableView = eiokVC.checksTableView.rect(forSection: index)
            let rectOfSectionInSuperview = eiokVC.checksTableView.convert(
                rectOfSectionInTableView,
                to: eiokVC.checksTableView.superview)
            let iconPoint = section?.headerIconContainer.convert(
                rectOfSectionInSuperview,
                to: section?.headerIconContainer.superview)
            let iconRect = CGRect(
                x: iconPoint?.minX ?? 0,
                y: iconPoint?.minY ?? 0,
                width: section?.headerIconContainer.frame.width ?? 0,
                height: section?.headerIconContainer.frame.height ?? 0)
            frames.append(iconRect)
        }
        return frames
    }

    func isFrameInFrame(subFrame: CGRect, superFrame: CGRect) -> Bool {
        if subFrame.maxY > superFrame.minY &&
            subFrame.minY < superFrame.maxY {
            return true
        }
        return false
    }

    func setEIOKIconsAlpha(alpha: CGFloat) {
        guard let eiokVC = eiokVC else {
            return
        }
        for index in 0..<eiokVC.checksTableView.numberOfSections {
            let section = eiokVC.checksTableView.headerView(forSection: index) as? VFEverythingIsOKChecksHeaderCell
            section?.headerIconContainer.alpha = alpha
        }
    }

    func actualFrame(of view: UIView?, to container: UIView? = nil) -> CGRect {
        guard let view = view else { return CGRect.zero }
        let position = view.superview?.convert(view.frame.origin, to: container)
        let frame = CGRect(
            x: position?.x ?? 0,
            y: position?.y ?? 0,
            width: view.frame.width,
            height: view.frame.height)
        return frame
    }

    func copyLabel(
        label: VFGLabel?,
        frame: CGRect? = nil,
        extraScrollOffset: CGFloat = 0,
        initialAlpha: CGFloat? = nil
    ) -> VFGLabel {
        guard let label = label else { return VFGLabel() }
        let copyLabel = VFGLabel()
        if let frame = frame {
            copyLabel.frame = frame
        } else {
            copyLabel.frame = actualFrame(
                of: label,
                to: eioManager.dashboardVC.view)
        }
        copyLabel.frame.origin.y += extraScrollOffset
        copyLabel.text = label.text
        copyLabel.font = label.font
        copyLabel.textColor = label.textColor
        copyLabel.textAlignment = label.textAlignment
        copyLabel.tintColor = label.tintColor
        if let initialAlpha = initialAlpha {
            copyLabel.alpha = initialAlpha
        }

        return copyLabel
    }

    func copyImageView(imageView: VFGImageView?, frame: CGRect? = nil, extraScrollOffset: CGFloat = 0) -> VFGImageView {
        guard let imageView = imageView else { return VFGImageView() }
        let copyImageView = VFGImageView()
        if let frame = frame {
            copyImageView.frame = frame
        } else {
            copyImageView.frame = actualFrame(of: imageView, to: imageView.superview)
        }
        copyImageView.frame.origin.y += extraScrollOffset
        copyImageView.image = imageView.image
        copyImageView.tintColor = imageView.tintColor
        copyImageView.alpha = imageView.alpha

        return copyImageView
    }
}

// MARK: Transition Labels Setup
extension VFGDashboardToEIOKAnimation {
    func setupTransitionLabels(
        extraOffset: CGFloat = 0,
        initialAlpha: CGFloat? = nil
    ) {
        guard let eiokVC = eiokVC else {
            return
        }
        let dashboardHeader = eioManager.dashboardHeader
        dashboardGreetingLabel = dashboardHeader?.statusContainerView?.subviews.first as? VFGLabel
        var originalLabels: [VFGLabel?] = [dashboardGreetingLabel]
        if eiokVC.eioModel?.eioStatus == .success {
            originalLabels.append(dashboardHeader?.accountTitleLabel)
        }
        transitionLabels = []
        originalLabels.forEach { label in
            transitionLabels.append(copyLabel(
                label: label,
                extraScrollOffset: extraOffset,
                initialAlpha: initialAlpha
            ))
        }
    }

    func finishTransition() {
        guard let eiokVC = eiokVC else {
            return
        }
        eiokVC.closeButton.alpha = 1
        eiokVC.checksTableView.alpha = 1
        eiokVC.descriptionLabelContainer.alpha = 1
        eioManager.backgroundView?.alpha = 1
        eioManager.dashboardHeader?.isHidden = false
        transitionLabels.forEach {
            $0.alpha = 0
            $0.removeFromSuperview()
        }

        transitionImageViews.forEach { imageView in
            imageView?.alpha = 0
            imageView?.removeFromSuperview()
        }

        displayLink?.invalidate()
        displayLink = nil
    }
}
