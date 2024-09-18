//
//  VFGMVA12DashboardTheme.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 02/06/2022.
//

import VFGMVA10Foundation

public class VFGMVA12DashboardTheme: VFGDashboardThemeProtocol {
    weak public var dashboardManager: VFGDashboardManager?
    private var initialTopHeightConstraint: CGFloat?

    public func modelSetupStepFinished(error: Error?) {
        guard let dashboardManager = dashboardManager else {
            return
        }
        guard dashboardManager.dashboardFinished else {
            prepareDashboard(error: error)
            return
        }
        dashboardManager.updateDashboardModels(error: error)
    }

    public func prepareDashboard(error: Error?) {
        guard let dashboardManager = dashboardManager else {
            return
        }
        let dashboardController = dashboardManager.dashboardController
        dashboardManager.dashboardController.eioModel = dashboardManager.eioModel
        dashboardManager.dashboardNavigation = DashboardNavigationController(rootViewController: dashboardController)
        dashboardManager.dashboardNavigation?.isNavigationBarHidden = true
        dashboardManager.delegate?.open(with: dashboardManager.dashboardNavigation, error: error)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let dashboardManager = dashboardManager else {
            return
        }
        dashboardManager.dashboardController.mva12RefreshControl?.scrollViewDidScroll(scrollView)
        let contentOffsetY = scrollView.contentOffset.y
        if initialTopHeightConstraint == nil {
            initialTopHeightConstraint = dashboardManager.dashboardController.topViewHeightConstraint.constant
        }
        guard let initialTopHeightConstraint = initialTopHeightConstraint else {
            return
        }
        let mva12HeaderView = dashboardManager.dashboardController.headerMVA12View
        let newTopViewHeightConstraint: CGFloat = initialTopHeightConstraint - contentOffsetY
        let dashboardBackgroundMinY = Constants.mva12DashboardBackgroundMinY
        switch contentOffsetY {
        case let value where value >= 0:
            // background is not moving
            dashboardManager.dashboardController.topViewHeightConstraint.constant = initialTopHeightConstraint
            mva12HeaderView?.scrollContent(offset: value)
        default:
            // stretch background
            dashboardManager.dashboardController.topViewHeightConstraint.constant = newTopViewHeightConstraint
            mva12HeaderView?.scrollContent(offset: contentOffsetY)
        }
        // check for scrolling top or bottom to show/hide status bar accordingly.
        UIView.animate(withDuration: 0.2) {
            dashboardManager.dashboardController.statusBarView?.alpha = contentOffsetY > 0 ? 1 : 0
        }
        // move white background accordingly to scroll gesture:
        let collectionOffset = newTopViewHeightConstraint + dashboardBackgroundMinY
        dashboardManager.dashboardController.collectionBackgroundTop.constant = collectionOffset
    }

    public func updateTilesBackgroundView() {
        guard let dashboardManager = dashboardManager else {
            return
        }
        let collectionBackgroundTop = (dashboardManager.customHeaderModel?.headerContainerHeight ?? 0.0) - 15
        dashboardManager.dashboardController.collectionBackgroundTop.constant = collectionBackgroundTop
    }
}
