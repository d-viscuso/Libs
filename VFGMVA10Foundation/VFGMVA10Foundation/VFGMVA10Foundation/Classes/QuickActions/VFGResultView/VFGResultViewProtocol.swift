//
//  VFGResultViewProtocol.swift
//  VFGMVA10Foundation
//
//  Created by Mohamed Abd ElNasser on 1/4/21.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

public protocol VFGResultViewProtocol: AnyObject {
    /// Called after clicking on the primary button
    func resultViewPrimaryButtonAction()
    /// Called after clicking on the secondary button
    func resultViewSecondaryButtonAction()
    /// Called after closing the quick action
    func quickActionsClose(isCloseButton: Bool)
}

public extension VFGResultViewProtocol {
    func quickActionsClose(isCloseButton: Bool) {}
    func resultViewSecondaryButtonAction() {}
}
