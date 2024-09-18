//
//  VFGDashboardThemeProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ramy Nasser on 02/06/2022.
//

import VFGMVA10Foundation
public protocol VFGDashboardThemeProtocol {
    var dashboardManager: VFGDashboardManager? { get set }
    func modelSetupStepFinished(error: Error?)
    func prepareDashboard(error: Error?)
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func updateTilesBackgroundView()
}
