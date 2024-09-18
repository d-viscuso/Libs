//
//  UITabBarItem+Extensions.swift
//  VFGMVA10Foundation
//
//  Created by Ayman Ata on 25/10/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

internal extension UITabBarItem {
    /// Creates new instance of UITabBarItem with the given model.
    /// - Parameters:
    ///    - model: An object of *VFGBaseTabBarItemProtocol* that contains needed data to initialize a UITabBarItem instance.
    convenience init(_ model: VFGBaseTabBarItemProtocol) {
        self.init()
        title = model.title
        image = model.image
        selectedImage = model.selectedImage
        badgeValue = model.badgeValue
    }
}
