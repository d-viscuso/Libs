//
//  VFGCVMProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Ahmed AbdElnabi on 31/08/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// CVM buttons action protocol.
public protocol VFGCVMProtocol: AnyObject {
    /// Notify the delegate once close button is pressed.
    func closeButtonDidPress()
    /// Notify the delegate once setup button is pressed.
    func setupButtonDidPress()
    /// Notify the delegate once edit button is pressed.
    func editButtonDidPress()
    /// Notify the delegate once toggle button is pressed.
    /// - Parameters:
    ///   - isToggleEnabled: Boolean that present the status of toggle
    func toggleButtonDidPress(isToggleEnabled: Bool)
}

public extension VFGCVMProtocol {
    func editButtonDidPress() {}
    func toggleButtonDidPress(isToggleEnabled: Bool = false) {}
}
