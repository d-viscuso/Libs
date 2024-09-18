//
//  VFGTabBarController.swift
//  VFGMVA10Foundation
//
//  Created by Ayman Ata on 25/10/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import UIKit

/// **VFGTabBarController** is a custom implementation of Apple's basic tab bar controller.
/// - Note: You must initialize this class with *init(tabBarItems: [VFGTabBarTabItemProtocol])* initializer to make it work properly.
final class VFGTabBarController: UITabBarController {
    /// Creates instance of VFGTabBarController with the given tab bar items.
    /// - Parameters:
    ///    - tabBarItems: An array of tab bar item that contains data for each tab.
    required init(tabBarItems: [VFGTabBarTabItemProtocol]) {
        super.init(nibName: nil, bundle: nil)
        setupViewControllers(with: tabBarItems)
        setupUI()
        selectedViewController?.tabBarItem.setTitleTextAttributes([.font: UIFont.vodafoneBold(14)], for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Sets up viewControllers for the tab bar controller.
    /// - Parameters:
    ///    - tabBarItems: An *Array* of VFGTabBarTabItemProtocol.
    private func setupViewControllers(with tabBarItems: [VFGTabBarTabItemProtocol]) {
        var controllers: [UIViewController] = []
        for tabBarItem in tabBarItems {
            var viewController = tabBarItem.viewController
            let tabItemModel = VFGBaseTabBarItem(
                title: tabBarItem.title,
                image: tabBarItem.image,
                id: tabBarItem.tabItemId,
                badgeValue: tabBarItem.badgeValue,
                selectedImage: tabBarItem.selectedImage)

            if tabBarItem.tabBarItmeControllerStyle == .overlay {
                let emptyTabViewController = VFGEmptyTabViewController()
                emptyTabViewController.controller = viewController
                viewController = emptyTabViewController
            }
            viewController.tabBarItem = UITabBarItem.init(tabItemModel)
            viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
            controllers.append(viewController)
        }
        self.viewControllers = controllers
    }

    private func setupUI() {
        tabBar.unselectedItemTintColor = .black
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        tabBar.shadowImage = nil
        tabBar.backgroundImage = nil
        tabBar.backgroundColor = .white
        tabBar.tintColor = .red
        tabBar.layer.borderWidth = 1.0
        tabBar.layer.borderColor = UIColor.lightGray.cgColor
    }

    override var selectedViewController: UIViewController? {
        didSet {
            guard let controllers = viewControllers else { return }
            for controller in controllers {
                let font = controller == selectedViewController ? UIFont.vodafoneBold(14) : UIFont.vodafoneRegular(14)
                controller.tabBarItem.setTitleTextAttributes([.font: font], for: .normal)
            }
        }
    }

    override var viewControllers: [UIViewController]? {
        didSet {
            guard let controllers = viewControllers else { return }
            for controller in controllers {
                controller.tabBarItem.setTitleTextAttributes(
                    [.foregroundColor: UIColor.VFGPrimaryDarkText], for: .selected)
                let font = controller == selectedViewController ? UIFont.vodafoneBold(14) : UIFont.vodafoneRegular(14)
                controller.tabBarItem.setTitleTextAttributes([.font: font], for: .normal)
            }
        }
    }
}

internal class VFGEmptyTabViewController: UIViewController {
    var controller: UIViewController?
}
