//
//  UIViewController+TopMostNavigationController.swift
//  VFGMVA10Group
//
//  Created by ahmed mahdy on 9/18/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import UIKit

extension UIViewController {
    func topMostNavigationViewController() -> UINavigationController? {
        if let presented = self.presentedViewController {
            return presented.topMostNavigationViewController()
        }
        if let navigation = self as? UINavigationController {
            return navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostNavigationViewController()
        }
        return nil
    }
}
