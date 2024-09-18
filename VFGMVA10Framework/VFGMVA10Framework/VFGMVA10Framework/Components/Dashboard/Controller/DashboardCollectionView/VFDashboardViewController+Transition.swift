//
//  VFDashboardViewController+Transition.swift
//  VFGMVA10Framework
//
//  Created by Mohamed Abd ElNasser on 11/27/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

extension VFDashboardViewController: UIViewControllerTransitioningDelegate {
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        VFGEIOManager.shared.animatedTransitioning(isPresenting: true)
    }

    public func interactionControllerForPresentation(
        using
        animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        VFGEIOManager.shared.interactionController()
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        VFGEIOManager.shared.animatedTransitioning(isPresenting: false)
    }

    public func interactionControllerForDismissal(
        using
        animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        VFGEIOManager.shared.interactionController()
    }
}
