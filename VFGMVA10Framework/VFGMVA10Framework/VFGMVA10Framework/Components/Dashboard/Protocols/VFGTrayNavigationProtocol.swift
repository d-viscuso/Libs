//
//  VFGTrayNavigationProtocol.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 2/18/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import UIKit

/// Confirm this Protocol and override its *open* method to initialize the view controller that will contain your Tray.
public protocol VFGTrayNavigationProtocol: AnyObject {
    /// Open the tray view controller.
    /// - Parameters:
    ///   - controller: Tray view controller that will be presented when you press on the tray button.
    ///   - error: Error you will use if the controller is nil.
    func open(with controller: VFGTrayViewController?, error: Error?)
}
