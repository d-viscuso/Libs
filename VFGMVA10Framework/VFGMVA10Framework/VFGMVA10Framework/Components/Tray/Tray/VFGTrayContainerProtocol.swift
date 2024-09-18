//
//  VFGTrayContainerProtocol.swift
//  VFGMVA10Group
//
//  Created by Mohamed Mahmoud Zaki on 7/10/19.
//  Copyright © 2019 Vodafone. All rights reserved.
//

import Foundation

/// Tray container protocol
public protocol VFGTrayContainerProtocol: AnyObject {
    /// Tray style
    var trayStyle: VFGTrayStyle { get }
    /// Tobi view controller container, default is *nil*.
    var tobiContainerVC: UIViewController? { get }
    /// Tobi key.
    var tobiKey: String { get }
    /// Boolean to enable or disable tobi messages, default is *true*.
    var tobiMessageEnabled: Bool { get }
    /// Tobi action type, default is *defaultAction*.
    var tobiActionType: TrayTobiAction { get }
}

public extension VFGTrayContainerProtocol {
    var tobiContainerVC: UIViewController? {
        return nil
    }
    var tobiMessageEnabled: Bool { true }
    var tobiActionType: TrayTobiAction { .defaultAction }
    /// Method to change tray state.
    func trayStateDidChange(to state: TrayState) {}
}

public enum TrayTobiAction {
    case customAction(tobiCustomAction: () -> Void)
    case defaultAction
}
public enum VFGTrayStyle: String {
    case trayWithTOBI
    case TOBI
    case none
    case noChange
}
