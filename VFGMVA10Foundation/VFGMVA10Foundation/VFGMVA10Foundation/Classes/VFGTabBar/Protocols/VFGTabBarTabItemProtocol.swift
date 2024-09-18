//
//  VFGTabBarTabItemProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Ayman Ata on 02/11/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation

/// **VFGTabBarTabItemProtocol** is a protocol repersenting the model for tab bar item in *VFGTaBarController*
public protocol VFGTabBarTabItemProtocol {
    /// ViewController of this tab bar item.
    var viewController: UIViewController { get set }
    /// Style of the viewController for this tab bar item, either will be a regular tab or will be presented as overlay when pressing on it's tab.
    var tabBarItmeControllerStyle: VFGTabBarItmeControllerStyle { get set }
    /// Title of the tab bar item.
    var title: String { get set }
    /// Image of the tab bar item.
    var image: UIImage { get set }
    /// Selected image of the tab bar item, this image will be shown on selection.
    var selectedImage: UIImage? { get set }
    /// Id for the tab bar item, this is used to identify this tab and send local notification to change it's badge value for example.
    var tabItemId: String? { get set }
    /// Value of the badge on tab bar item.
    var badgeValue: String? { get set }
}
