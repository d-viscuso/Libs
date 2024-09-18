//
//  MyAddressProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 03/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// My address provider protocol.
public protocol MyAddressProviderProtocol {
    /// My address controller.
    var myAddressViewController: MyAddressViewController? { get }
    /// Change address controller.
    var changeAddressViewController: VFGChangeAddressViewController? { get }
    /// Address model.
    var myAddress: VFGAddressModel? { get set }
}
