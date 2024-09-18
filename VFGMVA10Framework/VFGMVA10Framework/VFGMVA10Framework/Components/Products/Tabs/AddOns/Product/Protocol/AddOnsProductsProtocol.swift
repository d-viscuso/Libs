//
//  AddOnsProductsProtocol.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 9/8/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// AddOns products model.
public protocol AddOnsProductsProtocol {
    /// List of addOns product model.
    var addOns: [AddOnsProductModel]? { get }
}
