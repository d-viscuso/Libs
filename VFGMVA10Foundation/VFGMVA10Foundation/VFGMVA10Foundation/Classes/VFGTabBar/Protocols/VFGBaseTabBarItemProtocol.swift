//
//  VFGBaseTabBarItemProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Ayman Ata on 02/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// **VFGBaseTabBarItemProtocol** is protocol used to initialize *UITabBarItem*.
internal protocol VFGBaseTabBarItemProtocol {
    /// Title of the tab bar item.
    var title: String? { get set }
    /// Image of the tab bar item.
    var image: UIImage? { get set }
    /// Selected image of the tab bar item, this image will be shown on selection.
    var selectedImage: UIImage? { get set }
    /// Id for the tab bar item.
    var id: String? { get set }
    /// Value of the badge on tab bar item.
    var badgeValue: String? { get set }
}
