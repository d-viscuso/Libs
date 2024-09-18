//
//  VFGTrayModelProtocol.swift
//  VFGMVA10Group
//
//  Created by Sandra Morcos on 8/8/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import VFGMVA10Foundation
/// Controls sub tray item image size and title label font size
public enum SubTrayItemScale {
    /// Set image size to 32 and  label font size to 16 for selected sub tray and 14 for unselected
    case normal
    /// Set image size to 24 and  label font size to 10
    case small
}

/// Model that the TrayManager needs to navigate to *VFGTrayViewController* and setup it's Tray elements.
public protocol VFGTrayModelProtocol: AnyObject {
    /// Boolean to makes the Sub-Tray items scroll vertically if true, default is false.
    var enableAutoSwitchToVerticalSubTray: Bool { get }
    /// The *VFGTrayManager* trayDelegate.
    var trayDelegate: VFGTrayManagerProtocol? { get set }
    /// List of *VFGTrayItemProtocol* each item of the list is responsible for a Tray element.
    var trayItems: [VFGTrayItemProtocol] { get }
    /// Boolean to determine if Tobi is enabled or not.
    var isTobiEnabled: Bool? { get }
    /// Image when there's no tobi
    var tobiLessImage: UIImage? { get }
    /// Controls sub tray item image size and title label font size
    var subTrayItemScale: SubTrayItemScale? { get }
    /// Setup method where you can fetch the Tray data.
    func setup()
}

extension VFGTrayModelProtocol {
    public var enableAutoSwitchToVerticalSubTray: Bool {
        return false
    }

    public var tobiLessImage: UIImage? {
        VFGFrameworkAsset.Image.helpSupport
    }

    public var subTrayItemScale: SubTrayItemScale? { .normal }
}
