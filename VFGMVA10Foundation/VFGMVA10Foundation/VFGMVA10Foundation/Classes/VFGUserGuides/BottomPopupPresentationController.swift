//
//  BottomPopupPresentationController.swift
//  MyVodafone
//
//  Created by Ramy Nasser on 6/18/19.
//  Copyright © 2019 TSSE. All rights reserved.
//

import UIKit

class BottomPopupPresentationController: UIPresentationController {
    fileprivate var popUpAttributes: MVA10BottomPopupAttributesProtocol? {
        return presentedViewController as? MVA10BottomPopupAttributesProtocol
    }

    fileprivate var dimmingView: UIView?

    fileprivate var popupHeight: CGFloat { popUpAttributes?.getPopupHeight() ?? 400.0 }
    fileprivate var popupWidth: CGFloat { popUpAttributes?.getPopupWidth() ?? BottomPopupViewConstants.kPopupWidth }
    fileprivate var dimmingViewAlpha: CGFloat { popUpAttributes?.getDimmingViewAlpha() ?? 0.6 }
    fileprivate var dimmingViewBColor: UIColor { popUpAttributes?.getDimmingViewBackgroundColor() ?? .black }
    fileprivate var shouldPopupViewDiss: Bool { popUpAttributes?.shouldPopupViewDismissInteractivelty() ?? true }

    override var frameOfPresentedViewInContainerView: CGRect {
        let screenBounds = UIScreen.main.bounds
        let origin = CGPoint(x: (screenBounds.width - popupWidth) / 2.0, y: screenBounds.height - popupHeight)
        let size = CGSize(width: popupWidth, height: popupHeight)
        NSLog("frameOfPresentedViewInContainerView: \(origin)")
        return CGRect(origin: origin, size: size)
    }

    private func changeDimmingViewAlphaAlongWithAnimation(to alpha: CGFloat) {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView?.backgroundColor = dimmingViewBColor.withAlphaComponent(alpha)
            return
        }
        coordinator.animate { _ in
            self.dimmingView?.backgroundColor = self.dimmingViewBColor.withAlphaComponent(alpha)
        }
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let dimming = self.dimmingView else { return }
        containerView?.insertSubview(dimming, at: 0)
        changeDimmingViewAlphaAlongWithAnimation(to: dimmingViewAlpha)
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        changeDimmingViewAlphaAlongWithAnimation(to: 0)
    }

    @objc fileprivate func handleTap(_ tap: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }

    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        containerView?.setNeedsLayout()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.containerView?.layoutIfNeeded()
        }, completion: nil)
    }
}

private extension BottomPopupPresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView?.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        dimmingView?.backgroundColor = .clear

        if shouldPopupViewDiss {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            dimmingView?.isUserInteractionEnabled = true
            dimmingView?.addGestureRecognizer(tapGesture)
        }
    }
}
