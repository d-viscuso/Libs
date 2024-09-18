//
//  UIApplication+TopMostNavigationController.swift
//  VFGMVA10Group
//
//  Created by Mohamed Mahmoud Zaki on 7/14/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit
import VFGMVA10Foundation

extension UIApplication {
    /// A method used to return the top navigation controller.
    /// - Returns: *UINavigationController?*.
    public var topMostNavigationController: UINavigationController? {
        return keyWindow?.rootViewController?.topMostNavigationViewController()
    }
}
