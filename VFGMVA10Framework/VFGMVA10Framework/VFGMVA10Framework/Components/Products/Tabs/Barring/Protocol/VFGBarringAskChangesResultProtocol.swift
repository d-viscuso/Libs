//
//  VFGBarringAskChangesResultProtocol.swift
//  VFGMVA10Framework
//
//  Created by Trachani, Vasiliki, Vodafone on 20/5/22.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
/// Barring ask changes result protocol.
public protocol VFGBarringAskChangesResultProtocol: AnyObject {
    /// showing success view method.
    func showSuccessQuickResult()
    /// showing error view method.
    func showErrorQuickResult(model: VFGBarringItemViewModel)
}
