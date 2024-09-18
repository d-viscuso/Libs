//
//  VFGMyProductsProtectionProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 15/03/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

/// My products protection main screen protocol
public protocol VFGMyProductsProtectionProtocol: AnyObject {
    /// A method used to return a dictionary of each action key and its action
    func devicesActions() -> VFGActions
}
