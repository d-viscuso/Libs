//
//  VFGNavigationControllerProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Moamen Abd Elgawad on 08/07/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation
/// Delegation protocol for *VFGNavigationController* actions
public protocol VFGNavigationControllerProtocol: AnyObject {
    /// Handle *closeButton* press action in *MVA10NavigationView*
    func closeButtonDidPress()
    /// Handle *backButton* press action in *MVA10NavigationView*
    func backButtonDidPress()
}

extension VFGNavigationControllerProtocol {
    public func backButtonDidPress() {}
}
