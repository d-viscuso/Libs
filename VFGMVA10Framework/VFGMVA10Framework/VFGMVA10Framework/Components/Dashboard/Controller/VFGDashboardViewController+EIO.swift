//
//  VFGDashboardViewController+EIO.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 12/1/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

extension VFDashboardViewController: UpdateDashboardSectionHeightDelegate {
    func updateDashboardSectionHeight(completion: (() -> Void)? = nil) {
        var height: CGFloat
        if dashboardCardsModel?.myProductsModel?.image != nil {
            height = VFGUISetup.Defaults.dashboardHeaderMinMyProductsImageHeight
        } else {
            height = VFGUISetup.Defaults.dashboardEIOMinHeaderHeight
        }
        guard let collectionView = collectionView else { return }
        self.updateDashboardMinimumHeaderHeight(height)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func updateEIOKStatus(completion: (() -> Void)? = nil) {
        guard let status = eioModel?.eioStatus else { return }
        defer {
            if let collectionView = collectionView {
                self.setNeedsStatusBarAppearanceUpdate()
                if status == .success && oldStatus != .success {
                    if dashboardCardsModel?.myProductsModel?.image != nil {
                        self.updateDashboardMinimumHeaderHeight(
                            VFGUISetup.Defaults.dashboardHeaderMaxMyProductsImageHeight)
                    } else {
                        self.updateDashboardMinimumHeaderHeight(VFGUISetup.Defaults.dashboardEIOMaxHeaderHeight)
                    }
                    UIView.animate(
                        withDuration: 0.33,
                        animations: {
                            collectionView.collectionViewLayout.invalidateLayout()
                        }, completion: { _ in
                            completion?()
                        })
                } else {
                    UIView.animate(
                        withDuration: 0.3) {
                        collectionView.collectionViewLayout.invalidateLayout()
                    }
                }
            }
            oldStatus = eioModel?.eioStatus
        }
        VFGEIOManager.shared.updateEIOStatus(newStatus: status, oldStatus: oldStatus)
        updateBackground(status)
    }
}

protocol UpdateDashboardSectionHeightDelegate: AnyObject {
    /// Update *VFDashboardViewController* collection view section hegiht based on its contents
    /// - Parameters:
    ///    - completion: Actions to be done after updating section height
    func updateDashboardSectionHeight(completion: (() -> Void)?)
    /// Update EIO status and EIO section
    /// - Parameters:
    ///    - completion: Actions to be done after updating EIO status
    func updateEIOKStatus(completion: (() -> Void)?)
}
