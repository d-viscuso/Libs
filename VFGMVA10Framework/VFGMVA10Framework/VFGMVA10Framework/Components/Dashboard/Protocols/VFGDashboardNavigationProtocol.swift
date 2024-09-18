//
//  VFGDashboardNavigationProtocol.swift
//  VFGMVA10
//
//  Created by Mahmoud Amer on 8/8/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

/// Dashboard navigation protocol.
public protocol VFGDashboardNavigationProtocol: AnyObject {
    /// Action used to navigate to dashboard.
    /// - Parameters:
    ///     - controller: Dashboard view controller.
    ///     - error: Error in case something went wrong while creating the dashboard.
    func open(with controller: UIViewController?, error: Error?)
}
