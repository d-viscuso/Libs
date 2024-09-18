//
//  VFGSecureNetDataProviderProtocol.swift
//  VFGMVA10Framework
//
//  Created by Ahmed AbdElnabi on 19/02/2022.
//  Copyright © 2022 Vodafone. All rights reserved.
//

import Foundation
/// Data provider protocol for Secure net journey
public protocol VFGSecureNetDataProviderProtocol {
    /// Responsible for handling the result of fetching my products protection data
    /// - Parameters:
    ///    - completion: Optional closure to perform actions after fetching data is finished
    func fetchMyProducts(completion: @escaping (VFGMyProductsProtectionModel?, Error?) -> Void)
}
