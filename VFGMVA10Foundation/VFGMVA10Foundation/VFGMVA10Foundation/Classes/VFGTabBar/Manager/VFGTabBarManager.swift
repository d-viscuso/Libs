//
//  VFGTabBarManager.swift
//  VFGMVA10Foundation
//
//  Created by Ayman Ata on 10/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// **VFGTabBarManager** is manager class that responsible of creating custom UITabBarController and updating it's badge values.
/// - Note: You can access this class methods only within it's shared property.
public final class VFGTabBarManager: NSObject {
    private var tabBarController: VFGTabBarController
    /// The singleton of tabBarManager instance.
    public static var shared = VFGTabBarManager()

    private override init() {
        tabBarController = .init(tabBarItems: [])
    }

    /// Creates new instance of custoom **UITabBarController** with the given tab bar items.
    /// - Parameter tabBarItems: An *Array* of tab bar items.
    /// - Returns: Instance of UITabBarController embeding the given tab bar items.
    public final func setup(with tabBarItems: [VFGTabBarTabItemProtocol]) -> UITabBarController {
        tabBarController = .init(tabBarItems: tabBarItems)
        tabBarController.delegate = self
        return tabBarController
    }

    /// Sets or updates tab bar item badge value of viewController with the given className.
    /// - Parameters:
    ///   - className: A String value representing name of the root viewController that embeded in the tabBar.
    ///   - value: An integer value that appears on badge.
    /// - Note: If you are in a navigation stack (eg: the third level screen), you must give className of the root
    /// navigation (ie: the controller that being embeded in the tabBar) not the one you are currently in.
    public final func setTabBarItemBadgeForControllerWith(className: String, with value: Int?) {
        let tabBarItem = getTabBarItem(for: className)
        guard let value = value, value != 0 else {
            tabBarItem?.badgeValue = nil
            return
        }
        tabBarItem?.badgeValue = "\(value)"
    }

    private func getTabBarItem(for className: String) -> UITabBarItem? {
        let tabBarItems = tabBarController.tabBar.items ?? []
        for (index, controller) in (tabBarController.viewControllers ?? []).enumerated() {
            if let navigationVC = controller as? UINavigationController,
            let topViewContoller = navigationVC.viewControllers.first,
            topViewContoller.className == className {
                return getTabItem(with: index)
            }

            if let emptyVC = controller as? VFGEmptyTabViewController,
            emptyVC.controller?.className == className {
                return getTabItem(with: index)
            }

            if controller.className == className {
                return getTabItem(with: index)
            }
        }

        func getTabItem(with index: Int) -> UITabBarItem? {
            tabBarItems.count > index ? tabBarItems[index] : nil
        }

        return nil
    }
}

extension VFGTabBarManager: UITabBarControllerDelegate {
    public final func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard
            let emptyTab = viewController as? VFGEmptyTabViewController,
            let controller = emptyTab.controller
        else { return true }
        controller.modalPresentationStyle = .overFullScreen
        self.tabBarController.present(controller, animated: true)
        return false
    }
}
