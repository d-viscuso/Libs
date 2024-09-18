//
//  MyAddressProvider.swift
//  VFGMVA10Framework
//
//  Created by Hussein Kishk on 03/01/2021.
//  Copyright © 2021 Vodafone. All rights reserved.
//

import Foundation

/// My address provider
public class MyAddressProvider: MyAddressProviderProtocol {
    public var myAddress: VFGAddressModel?

    public init() {}

    /// Computed property that returns initialized *MyAddressViewController*.
    public var myAddressViewController: MyAddressViewController? {
        let myAddressViewController = MyAddressViewController.instance(
            from: "MyAddress",
            with: "MyAddressViewController",
            bundle: .mva10Framework
        )
        return myAddressViewController as? MyAddressViewController
    }

    /// Computed property that returns initialized *VFGChangeAddressViewController*.
    public var changeAddressViewController: VFGChangeAddressViewController? {
        let changeAddressViewController = VFGChangeAddressViewController.instance(
            from: "VFGChangeAddress",
            with: "VFGChangeAddressViewController",
            bundle: .mva10Framework
        )
        return changeAddressViewController as? VFGChangeAddressViewController
    }
}
