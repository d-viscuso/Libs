//
//  VFDashboardViewController+Scroll.swift
//  VFGMVA10Group
//
//  Created by Mahmoud Amer on 8/8/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

// MARK: - UIScrollView Delegate
extension VFDashboardViewController {
    /// *VFDashboardViewController* scrolling process start
    /// - Parameters:
    ///    - scrollView: *VFDashboardViewController* scroll view
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lifeCycleDelegate?.dashboardScrollViewWillBeginDragging(scrollView)
        VFGEIOManager.shared.scrollViewWillBeginDragging()
    }
    /// *VFDashboardViewController* scrolling process end
    /// - Parameters:
    ///    - scrollView: *VFDashboardViewController* scroll view
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        lifeCycleDelegate?.dashboardScrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        let dashboardManager = VFGManagerFramework.dashboardDelegate?.dashboardManager
        let isAutoThresholdScrolling = dashboardManager?.autoThresholdScrolling ?? true
        if !decelerate && isAutoThresholdScrolling {
            checkDiscoverThreshold()
        }
        VFGEIOManager.shared.scrollViewDidEndDragging(willDecelerate: decelerate)
        let pullRatio = getPullRatio(scrollView)
        if checkIfLastItemIsFunFact() && (pullRatio >= 1 || pullRatio == 0) {
            updateLastItem(height: Constants.dashboardFunFactHeight)
        }
        if isMVA12Theme && topViewHeightConstraint.constant > 0 {
            VFGFloatingTobiView.shared.moveTobiToBoundaryView()
        }
    }
    /// *VFDashboardViewController* scroll view stopped scrolling
    /// - Parameters:
    ///    - scrollView: *VFDashboardViewController* scroll view
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        lifeCycleDelegate?.dashboardScrollViewDidEndDecelerating(scrollView)
        VFGEIOManager.shared.scrollViewDidEndDecelerating()
        footerDidEndDecelerating(scrollView)
        if isMVA12Theme && topViewHeightConstraint.constant > 0 {
            VFGFloatingTobiView.shared.moveTobiToBoundaryView()
        }
    }
    /// *VFDashboardViewController* scroll view finished scrolling
    /// - Parameters:
    ///    - scrollView: *VFDashboardViewController* scroll view
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        lifeCycleDelegate?.dashboardScrollViewDidScroll(scrollView)
        updateTilesBackgroundView()
        collectionView.visibleCells.forEach { cell in
            guard let dashboardCell = cell as? VFDashboardCell else {
                return
            }
            if dashboardCell.viewComponentEntry is DashboardFunFactComponentEntry {
                footerDidScroll(dashboardCell: dashboardCell, pullRatio: getPullRatio(scrollView))
            } else {
                cellDidScroll(dashboardCell: dashboardCell)
            }
        }
        let dashboardManager = VFGManagerFramework.dashboardDelegate?.dashboardManager
        let theme = dashboardManager?.dashboardTheme
        theme?.scrollViewDidScroll(scrollView)
        if isMVA12Theme && VFGFloatingTobiView.shared.frame.intersects(topView.frame) {
            VFGFloatingTobiView.shared.moveTobiToBoundaryView()
        }
    }
    /// Handle *VFDashboardViewController* collection view cell position
    /// - Parameters:
    ///    - dashboardCell: Currently scrolled collection view cell
    func cellDidScroll(dashboardCell: VFDashboardCell) {
        let currentCellY = collectionView.convert(dashboardCell.center, to: view)
        let viewHeight = view.frame.maxY + dashboardCell.frame.maxY
        let offset = currentCellY.y / viewHeight

        var percentage = offset > 1 ? 1 : offset
        percentage = percentage < 0 ? 0 : percentage

        dashboardCell.viewComponentEntry?.didScroll(percentage: offset)
    }

    /// Update dashboard tiles background view constraints
    func updateTilesBackgroundView() {
        let dashboardManager = VFGManagerFramework.dashboardDelegate?.dashboardManager
        let theme = dashboardManager?.dashboardTheme
        theme?.updateTilesBackgroundView()
    }
    /// Update minimun height for dashboard header view
    /// - Parameters:
    /// - height: New height to update dashboard header view height
    func updateDashboardMinimumHeaderHeight(_ height: CGFloat) {
        VFGUISetup.headerExtraHeight = height - VFGUISetup.Defaults.dashboardEIOMinHeaderHeight
    }
}
