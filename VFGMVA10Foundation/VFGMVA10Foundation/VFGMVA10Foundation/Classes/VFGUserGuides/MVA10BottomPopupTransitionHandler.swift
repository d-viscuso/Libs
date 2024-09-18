//
//  MVA10BottomPopupTransitionHandler.swift
//  MyVodafone
//
//  Created by Ramy Nasser on 6/18/19.
//  Copyright © 2019 TSSE. All rights reserved.
//

import UIKit

/// A class which include a set of methods that vend objects used to manage a fixed-length or interactive transition of popup view controller.
public class MVA10BottomPopupTransitionHandler: NSObject, UIViewControllerTransitioningDelegate {
    private var presentAnimator: MVA10BottomPopupPresentAnimator?
    private var dismissAnimator: MVA10BottomPopupDismissAnimator?
    private var interactionController: MVA10BottomPopupDismissInteractionCtr?
    private weak var popupViewController: MVA10BottomPresentableViewController?
    fileprivate weak var popupDelegate: MVA10BottomPopupDelegate?

    var isInteractiveDismissStarted = false

    /// Initializer for bottom popup transition handler.
    /// - Parameter popupViewController: View controller which is going to be presented.
    public init(popupViewController: MVA10BottomPresentableViewController) {
        self.popupViewController = popupViewController

        presentAnimator = MVA10BottomPopupPresentAnimator(attributesOwner: popupViewController)
        dismissAnimator = MVA10BottomPopupDismissAnimator(attributesOwner: popupViewController)
    }

    func viewLoaded(withPopupDelegate delegate: MVA10BottomPopupDelegate?) {
        self.popupDelegate = delegate
        guard let popupViewController = popupViewController else {
            return
        }
        if popupViewController.shouldPopupDismissInteractivelty() {
            interactionController = MVA10BottomPopupDismissInteractionCtr(presentedViewController: popupViewController)
            interactionController?.delegate = self
        }
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomPopupPresentationController(presentedViewController: presented, presenting: presenting)
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimator
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimator
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteractiveDismissStarted ? interactionController : nil
    }
}

extension MVA10BottomPopupTransitionHandler: MVA10BottomPopupDismissInteractionControllerDelegate {
    func dismissInteraction(_ controller: MVA10BottomPopupDismissInteractionCtr, didChangePercentFrom oldValue: CGFloat, to newValue: CGFloat) {
        popupDelegate?.bottomPopupDismissInteraction(didChangedPercentFrom: oldValue, to: newValue)
    }
}
