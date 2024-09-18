//
//  AddOnsCVMDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Esraa Eldaltony on 9/20/20.
//  Copyright © 2020 Vodafone. All rights reserved.
//

import Foundation

/// AddOns CVM data provider protocol
public protocol AddOnsCVMDataProviderProtocol {
    typealias FetchAddOnsCVMCompletion = ((AddOnsCVMModelProtocol?, Error?) -> Void)?
    /// Fetch AddOns CVM data.
    /// - Parameters:
    ///     - completion: *FetchAddOnsCVMCompletion* is a typealis for *((AddOnsCVMModelProtocol?, Error?) -> Void)?*
    func fetchAddOnsCVM(completion: FetchAddOnsCVMCompletion)
}
