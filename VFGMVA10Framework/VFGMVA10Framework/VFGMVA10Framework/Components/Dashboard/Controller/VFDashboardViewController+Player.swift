//
//  VFDashboardViewController+Player.swift
//  VFGMVA10Framework
//
//  Created by Giovanni Romaniello on 31/08/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

extension VFDashboardViewController {
    func playVideo() {
        guard let visibleCells = collectionView?.visibleCells else { return }
        visibleCells.forEach { cell in
            guard let dashboardCell = cell as? VFDashboardCell else { return }
            dashboardCell.viewComponentEntry?.willDisplay()
        }
    }

    func pauseVideo() {
        guard let visibleCells = collectionView?.visibleCells else { return }
        visibleCells.forEach { cell in
            guard let dashboardCell = cell as? VFDashboardCell else { return }
            dashboardCell.viewComponentEntry?.didEndDisplay()
        }
    }
}
