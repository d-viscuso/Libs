//
//  VFGDashboardManager+RefreshLayout.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 20/06/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
extension VFGDashboardManager {
    /// hide *VFDashboardViewController* item
    /// - Parameter indexPath: indexPath of sections to be refreshed
    public func hideItem(at indexPath: IndexPath, completion: (() -> Void)? = nil) {
        guard dashboardController.dashboardDataSource != nil else { return }
        dashboardController.dashboardDataSource?.removeItem(at: indexPath) { isItemRemoved, isSectionRemoved in
            DispatchQueue.main.async { [weak self] in
                if isItemRemoved {
                    self?.dashboardController.collectionView.deleteItems(at: [indexPath])
                }
                if isSectionRemoved {
                    self?.dashboardController.collectionView.deleteSections(.init(integer: indexPath.section))
                }
                completion?()
            }
        }
    }
}
