//
//  VFGDashboardManager+Protocols.swift
//  VFGMVA10Framework
//
//  Created by Atta Ahmed on 03/08/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import VFGMVA10Foundation

extension VFGDashboardManager: VFGDashboardManagerProtocol {
    public func reloadDashboard() {
        dashboardController.collectionView.reloadData()
    }
    public func EIOSetupFinished(error: Error?) {
        EIOFinished = true
        dashboardTheme?.modelSetupStepFinished(error: error)
    }

    public func presentSecondLevel(with controller: UIViewController) {
        guard controller is UINavigationController else {
            let navController = MVA10NavigationController(rootViewController: controller)
            controller.setBackgroundImage(image: VFGFrameworkAsset.Image.wavesGrey)
            navController.setTitle(title: controller.title ?? "", for: controller)
            dashboardPresent(navController)
            return
        }
        dashboardPresent(controller)
    }

    public func dashboardItemsSetupFinished(error: Error?) {
        dashboardFinished = true
        dashboardTheme?.modelSetupStepFinished(error: error)
    }
}

extension VFGDashboardManager: VFGEIOManagerProtocol {
    public func statusUpdated() {
        dashboardController.updateEIOKStatus()
    }
}

extension VFGDashboardManager: VFGTrayNavigationProtocol {
    public func open(with controller: VFGTrayViewController?, error: Error?) {
        trayController = controller
        if error != nil {
            delegate?.open(with: nil, error: error)
        } else {
            trayFinished = true
            dashboardTheme?.modelSetupStepFinished(error: error)
        }
    }
}
