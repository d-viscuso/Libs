//
//  UIViewController+IsModal.swift
//  VFGMVA10Foundation
//
//  Created by Abdullah Soylemez on 24.03.2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Checks if the current UIViewController instance is presented modally.
	public var isModal: Bool {
		let presentingIsModal = presentingViewController != nil

		let presentingIsNavigation = navigationController?
			.presentingViewController?
			.presentedViewController == navigationController

		let presentingIsTabBar = tabBarController?
			.presentingViewController
			is UITabBarController

		return presentingIsModal || presentingIsNavigation || presentingIsTabBar
	}
}
