//
//  VFGDashboardNavigationController.swift
//  VFGMVA10Framework
//
//  Created by Yahya Saddiq on 12/1/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation
/// Navigation controller for dashboard
class DashboardNavigationController: UINavigationController {
    /// First child of navigation controller
    var rootController: VFDashboardViewController? {
        return children.first as? VFDashboardViewController
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        rootViewController.loadViewIfNeeded()
        view.backgroundColor = .clear
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
