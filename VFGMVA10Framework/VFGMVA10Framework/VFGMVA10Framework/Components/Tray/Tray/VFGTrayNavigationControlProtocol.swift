//
//  VFGTrayNavigationControlProtocol.swift
//  VFGMVA10Framework
//
//  Created by Amr Koritem on 15/05/2022.
//

/// The object that conforms to this protocol can override the implementation of navigation logic of *VFGTrayViewController* .
public protocol VFGTrayNavigationControlProtocol: AnyObject {
    /// Method that controls how the screen does screen for item navigation.
    /// - Parameters:
    ///    - trayItem: the item selected triggerring navigation.
    func navigateToScreenForItem(trayItem: VFGTrayItemModel)
}
