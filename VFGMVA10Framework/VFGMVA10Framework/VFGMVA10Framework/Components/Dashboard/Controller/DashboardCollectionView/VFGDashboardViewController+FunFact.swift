//
//  VFGDashboardViewController+FunFact.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 15/02/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
import UIKit
import VFGMVA10Foundation

// MARK: - UIScrollView Delegate
extension VFDashboardViewController {
    // Handle *VFDashboardViewController* collection view cell position
    /// - Parameters:
    ///    - dashboardCell: Currently scrolled collection view cell
    ///    - pullRatio: ratio that scrolling is pull

    func footerDidScroll(dashboardCell: VFDashboardCell, pullRatio: CGFloat) {
        dashboardCell.viewComponentEntry?.didScroll(percentage: CGFloat(pullRatio))
        if pullRatio < 1 && !isFunFactLoading {
            isFunFactLoading.toggle()
            updateLastItem(height: Constants.dashboardFunFactHeight)
        }
    }
    /// get last item in the list of dashboard
    private func getLastItemModel() -> BaseItemViewModel? {
        let lastSection = IndexPath(item: 0, section: collectionView.numberOfSections - 1)
        let itemModel = dashboardDataSource?.cardAtIndex(indexPath: lastSection)
        return itemModel
    }
    /// get the pull ratio for pulling the bottom of dashboard
    func getPullRatio(_ scrollView: UIScrollView) -> CGFloat {
        let threshold = 100.0
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - 50
        let diffHeight = contentHeight - contentOffset
        let frameHeight = scrollView.bounds.size.height
        var triggerThreshold = Float((diffHeight - frameHeight)) / Float(threshold)
        triggerThreshold = min(triggerThreshold, 0.0)
        let pullRatio = min(abs(triggerThreshold), 1.0)
        return CGFloat(pullRatio)
    }
    /// compute the offset and call the load method
    func footerDidEndDecelerating(_ scrollView: UIScrollView) {
        if checkIfLastItemIsFunFact() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.isFunFactLoading = false
            }
        }
    }
    /// update last item height in the list of dashboard
    func updateLastItem(height: CGFloat) {
        let itemModel = getLastItemModel()
        latestBouncedHeight = height
        UIView.animate(
            withDuration: 0.2,
            delay: 0.1,
            options: .curveEaseInOut,
            animations: {
                itemModel?.itemHeight = height
                self.collectionView.reloadData()
            }, completion: nil)
    }
    /// check if last item in dashboard if fun fact item or not
    func checkIfLastItemIsFunFact() -> Bool {
        let itemModel = getLastItemModel()
        guard itemModel?.componentEntry is DashboardFunFactComponentEntry else {
            return false
        }
        return true
    }
}
