//
//  VFGMVA10DashboardTheme.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 02/06/2022.
//

import VFGMVA10Foundation
import CoreGraphics

class VFGMVA10DashboardTheme: VFGDashboardThemeProtocol {
    weak var dashboardManager: VFGDashboardManager?

    func modelSetupStepFinished(error: Error?) {
        guard let dashboardManager = dashboardManager else {
            return
        }
        guard dashboardManager.trayFinished else {
            return
        }

        if dashboardManager.trayPresented == false {
            prepareDashboard(error: error)
            dashboardManager.trayPresented = true
        }

        guard dashboardManager.dashboardFinished else {
            return
        }

        dashboardManager.updateDashboardModels(error: error)
    }

    func prepareDashboard(error: Error?) {
        guard let dashboardManager = dashboardManager else {
            return
        }
        let autoRefreshIntervalInSeconds = dashboardManager.autoRefreshIntervalInSeconds
        let multipleAccountsBannerInterval = dashboardManager.multipleAccountsBannerInterval

        dashboardManager.dashboardController.eioModel = dashboardManager.eioModel
        dashboardManager.dashboardController.autoRefreshIntervalInSeconds = autoRefreshIntervalInSeconds
        dashboardManager.dashboardController.multipleAccountsBannerInterval = multipleAccountsBannerInterval
        if dashboardManager.trayController == nil {
            dashboardManager.showDashboard(error: error)
        } else {
            let dashboardVC = dashboardManager.dashboardController
            dashboardManager.dashboardNavigation = DashboardNavigationController(rootViewController: dashboardVC)
            dashboardManager.dashboardNavigation?.isNavigationBarHidden = true
            dashboardManager.showTray(error: error)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let dashboardManager = dashboardManager else {
            return
        }

        updateTilesBackgroundView()

        let contentOffsetY = scrollView.contentOffset.y
        if let customHeaderModel = VFGManagerFramework.dashboardDelegate?.dashboardManager?.customHeaderModel {
            let topViewHeightConstraintConstant = dashboardManager.dashboardController.topViewHeightConstraint.constant
            let newTopViewHeightConstraint: CGFloat = topViewHeightConstraintConstant - contentOffsetY

            let safeAreaTopInset: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0.0
            let minHeight: CGFloat = dashboardManager.dashboardController.minTopViewHeight + safeAreaTopInset

            if newTopViewHeightConstraint <= minHeight {
                dashboardManager.dashboardController.topViewHeightConstraint.constant = minHeight
            } else if newTopViewHeightConstraint >= customHeaderModel.headerContainerHeight {
                let topViewHeightConstraint = customHeaderModel.headerContainerHeight + safeAreaTopInset
                dashboardManager.dashboardController.topViewHeightConstraint.constant = topViewHeightConstraint
            } else {
                dashboardManager.dashboardController.topViewHeightConstraint.constant = newTopViewHeightConstraint
                scrollView.contentOffset.y = 0
            }
        } else {
            // check for scrolling top or bottom to show/hide status bar accordingly.
            UIView.animate(withDuration: 0.2) {
                dashboardManager.dashboardController.statusBarView?.alpha = contentOffsetY > 0 ? 1 : 0
            }
            dashboardManager.dashboardController.setNeedsStatusBarAppearanceUpdate()
        }
    }

    func updateTilesBackgroundView() {
        guard let dashboardManager = dashboardManager,
            let collectionView = dashboardManager.dashboardController.collectionView else {
            return
        }
        let backgroundMinY = Constants.dashboardBackgroundMinY - dashboardManager.collectionBackgroundExtraTop
        if dashboardManager.eioModel != nil {
            let contentOffset = collectionView.contentOffset.y
            let collectionBackgroundTop = getEioCollectionTopConstraint(
                collectionContentOffset: contentOffset,
                backgroundMinY: backgroundMinY)
            setCollectionBackgroundTop(to: collectionBackgroundTop)
        } else {
            setCollectionBackgroundTop(to: backgroundMinY)
        }
    }

    func setCollectionBackgroundTop(to constant: CGFloat) {
        guard let dashboardManager = dashboardManager else { return }
        let collectionBackgroundTop = constant + dashboardManager.collectionBackgroundExtraTop
        dashboardManager.dashboardController.collectionBackgroundTop.constant = collectionBackgroundTop
    }

    func getEioCollectionTopConstraint(collectionContentOffset: CGFloat, backgroundMinY: CGFloat) -> CGFloat {
        let backgroundTopConstant = VFGUISetup.dashboardBackgroundTopConstant
        let collectionPadding = Constants.dashboardCollectionPadding
        let backgroundMargin = Constants.dashboardBackgroundMargin
        let topConstant = backgroundTopConstant
            - collectionContentOffset
            - collectionPadding
            + backgroundMargin
        if dashboardManager?.eioModel is VFGDisableEIO {
            return topConstant
        }
        return (topConstant >= 0) ? topConstant : backgroundMinY
    }
}
