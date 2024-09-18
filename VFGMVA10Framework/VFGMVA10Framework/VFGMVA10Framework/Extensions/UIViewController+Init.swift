//
//  UIViewController+Init.swift
//  VFGMVA10
//
//  Created by Mohamed Mahmoud Zaki on 2/25/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

public extension UIViewController {
    internal class var dashboardViewController: VFDashboardViewController {
        return VFDashboardViewController.instance(
            from: AppStoryboard.main.rawValue,
            with: "VFDashboardViewController",
            bundle: Bundle.mva10Framework)
    }

    internal static func relatedAppsViewController() -> VFGRelatedAppsViewController {
        return VFGRelatedAppsViewController.instantiate(fromAppStoryboard: .discovery)
    }
}
